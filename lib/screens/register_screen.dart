import 'package:flutter/material.dart';
import '../services/auth_service.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final registerController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
final authService = AuthService();
  String selectedRole = 'Student';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    registerController.dispose();
    passwordController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1565C0),
            Color(0xFF42A5F5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(24),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.school,
                      size: 70,
                      color: Colors.blue,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    const Text(
                      'Join Campus Pulse',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    DropdownButtonFormField<
                        String>(
                      value: selectedRole,
                      decoration:
                          InputDecoration(
                        labelText: 'Role',
                        prefixIcon:
                            const Icon(
                          Icons.person,
                        ),
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      15),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Student',
                          child:
                              Text('Student'),
                        ),
                        DropdownMenuItem(
                          value: 'Teacher',
                          child:
                              Text('Teacher'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedRole =
                              value!;
                        });
                      },
                    ),

                    const SizedBox(
                        height: 20),

                    TextField(
                      controller:
                          nameController,
                      decoration:
                          InputDecoration(
                        labelText:
                            'Full Name',
                        prefixIcon:
                            const Icon(
                          Icons.badge,
                        ),
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      15),
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 20),

                    TextField(
                      controller:
                          emailController,
                     decoration: InputDecoration(
  labelText: 'VIT Email',
  hintText: 'abc123@vitstudent.ac.in',
 
  prefixIcon: const Icon(
    Icons.email,
  ),
  border: OutlineInputBorder(
    borderRadius:
        BorderRadius.circular(15),
  ),
),
                    ),

                    const SizedBox(
                        height: 20),

                    TextField(
                      controller:
                          registerController,
                      decoration:
                          InputDecoration(
                        labelText:
                            'Register Number',
                        prefixIcon:
                            const Icon(
                          Icons.numbers,
                        ),
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      15),
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 20),

                   TextField(
  controller: passwordController,
  obscureText: !isPasswordVisible,
  decoration: InputDecoration(
    labelText: 'Password',
    prefixIcon: const Icon(
      Icons.lock,
    ),
    suffixIcon: IconButton(
      icon: Icon(
        isPasswordVisible
            ? Icons.visibility
            : Icons.visibility_off,
      ),
      onPressed: () {
        setState(() {
          isPasswordVisible =
              !isPasswordVisible;
        });
      },
    ),
    border: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(15),
    ),
  ),
),

                    const SizedBox(
                        height: 25),

                    SizedBox(
                      width:
                          double.infinity,
                      height: 50,
                      child:
                          ElevatedButton(
                        style:
                            ElevatedButton
                                .styleFrom(
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    15),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            final email =
    emailController.text.trim();

if (!email.endsWith(
        '@vitstudent.ac.in') &&
    !email.endsWith(
        '@vit.ac.in')) {
  ScaffoldMessenger.of(context)
      .showSnackBar(
    const SnackBar(
      content: Text(
        'Please use a valid VIT email address',
      ),
    ),
  );
  return;
}
                            await authService
                                .registerUser(
                              name:
                                  nameController
                                      .text
                                      .trim(),
                              email:
                                  emailController
                                      .text
                                      .trim(),
                              registerNumber:
                                  registerController
                                      .text
                                      .trim(),
                              password:
                                  passwordController
                                      .text
                                      .trim(),
                              role:
                                  selectedRole,
                            );

                            if (mounted) {
                              showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => Dialog(
    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(20),
    ),
    child: Padding(
      padding:
          const EdgeInsets.all(20),
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [

          const CircleAvatar(
            radius: 35,
            backgroundColor:
                Colors.green,
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 35,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          const Text(
            'Account Created!',
            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          const Text(
            'Your Campus Pulse account has been created successfully.',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(
            height: 25,
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {

                Navigator.pop(
                  context,
                );

                Navigator.pop(
                  context,
                );
              },
              child: const Text(
                'Continue',
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);

                              
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger
                                      .of(
                                          context)
                                  .showSnackBar(
                                SnackBar(
                                  content:
                                      Text(
                                    e.toString(),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Register',
                          style:
                              TextStyle(
                            fontSize:
                                16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 15),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        const Text(
                          'Already have an account?',
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                                context);
                          },
                          child:
                              const Text(
                            'Login',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
}