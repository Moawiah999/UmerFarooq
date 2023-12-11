

import 'package:flutter/material.dart';
import 'package:project_management/core/core_colors.dart';
import 'package:project_management/models/project_detail_model.dart';
import 'package:project_management/repositories/project_repository.dart';

import '../supporting_widgets/showErrorPopup.dart';
import 'home_screen.dart';

class AddProjectScreen extends StatefulWidget {
  final ProjectDetailModel? projectDetailModel;


  const AddProjectScreen({super.key, this.projectDetailModel});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {

  late TextEditingController projectNameController = TextEditingController(text: widget.projectDetailModel==null?"":widget.projectDetailModel!.projectName);
  late TextEditingController addressController = TextEditingController(text: widget.projectDetailModel==null?"":widget.projectDetailModel!.address);
  late TextEditingController tenantNameController = TextEditingController(text: widget.projectDetailModel==null?"":widget.projectDetailModel!.tenantName);
  late TextEditingController tenantPhoneController = TextEditingController(text: widget.projectDetailModel==null?"":widget.projectDetailModel!.tenantPhone);
  late TextEditingController lockboxCodeController = TextEditingController(text: widget.projectDetailModel==null?"":widget.projectDetailModel!.lockBoxCode);
  late TextEditingController emergencyDetailController = TextEditingController(text: widget.projectDetailModel==null?"":widget.projectDetailModel!.emergencyDetail);
  late TextEditingController emergencyNameController = TextEditingController(text: widget.projectDetailModel==null?"":widget.projectDetailModel!.emergencyPersonName);
  late TextEditingController emergencyPhoneController = TextEditingController(text: widget.projectDetailModel==null?"":widget.projectDetailModel!.emergencyPersonPhone);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,

        body: loading?Center(child: CircularProgressIndicator(color: lightBlack,),):
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: projectNameController,
                    cursorColor: lightBlack,
                    style: TextStyle(color: lightBlack),
                    decoration:  InputDecoration(
                      labelStyle: TextStyle(color: lightBlack),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      disabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow), // Change underline color
                    ),
                      labelText: 'Project Name',
                      icon: Icon(Icons.business,color: lightBlack),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter project name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: addressController,
                    cursorColor: lightBlack,
                    style: TextStyle(color: lightBlack),
                    decoration:  InputDecoration(
                      labelStyle: TextStyle(color: lightBlack),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      disabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      icon: Icon(Icons.location_on,color: lightBlack,),
                      labelText: 'Address',

                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: tenantNameController,
                    cursorColor: lightBlack,
                    style: TextStyle(color: lightBlack),
                    decoration:  InputDecoration(
                      labelStyle: TextStyle(color: lightBlack),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      disabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      icon: Icon(Icons.person,color: lightBlack,),
                      labelText: 'Tenant name',

                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter tenant name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: tenantPhoneController,
                    cursorColor: lightBlack,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: lightBlack),
                    decoration:  InputDecoration(
                      labelStyle: TextStyle(color: lightBlack),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      disabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      icon: Icon(Icons.contact_phone,color: lightBlack,),
                      labelText: 'Tenant phone Number',

                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Tenant phone Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: emergencyNameController,
                    cursorColor: lightBlack,
                    style: TextStyle(color: lightBlack),
                    decoration:  InputDecoration(
                      labelStyle: TextStyle(color: lightBlack),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      disabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      icon: Icon(Icons.contact_page_outlined,color: lightBlack,),
                      labelText: 'Emergency contact person name',

                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter person name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: emergencyPhoneController,
                    keyboardType: TextInputType.phone,
                    cursorColor: lightBlack,
                    style: TextStyle(color: lightBlack),
                    decoration:  InputDecoration(
                      labelStyle: TextStyle(color: lightBlack),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      disabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      icon: Icon(
                        Icons.contact_emergency,
                        color: lightBlack,),
                      labelText: 'Emergency contact person number',

                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter person number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: emergencyDetailController,
                    cursorColor: lightBlack,
                    style: TextStyle(color: lightBlack),
                    decoration:  InputDecoration(
                      labelStyle: TextStyle(color: lightBlack),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      disabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow), // Change underline color
                    ),
                      labelText: 'Emergency Contact Details',
                      icon: Icon(Icons.warning,color: lightBlack),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Emergency Contact Details';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16.0),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: lockboxCodeController,
                    cursorColor: lightBlack,
                    style: TextStyle(color: lightBlack),
                    decoration:  InputDecoration(
                      labelStyle: TextStyle(color: lightBlack),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),
                      disabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Change underline color
                      ),enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow), // Change underline color
                    ),
                      labelText: 'Lockbox Code',
                      icon: Icon(Icons.lock,color: lightBlack),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter LockBoxCode';
                      }
                      return null;
                    },

                  ),



                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        addProject();
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool loading = false;

  Future addProject() async {
    if (_formKey.currentState!.validate()) {
      try{
        setState(() {
          loading = true;
        });

        ProjectRepository projectRepository = ProjectRepository();
        if(widget.projectDetailModel==null){
          await projectRepository.addProject(
              ProjectDetailModel(
                  projectName: projectNameController.text.toString(),
                  address: addressController.text.toString(),
                  tenantName: tenantNameController.text.toString(),
                  tenantPhone: tenantPhoneController.text.toString(),
                  emergencyPersonName: emergencyNameController.text.toString(),
                  emergencyPersonPhone: emergencyPhoneController.text.toString(),
                  emergencyDetail: emergencyDetailController.text.toString(),
                  lockBoxCode: lockboxCodeController.text.toString(),
              )
          ).then((value) => {

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context)=>const HomeScreen()))

          });
        }else{

          await projectRepository.editProject(
              ProjectDetailModel(
                projectName: projectNameController.text.toString(),
                address: addressController.text.toString(),
                tenantName: tenantNameController.text.toString(),
                tenantPhone: tenantPhoneController.text.toString(),
                emergencyPersonName: emergencyNameController.text.toString(),
                emergencyPersonPhone: emergencyPhoneController.text.toString(),
                emergencyDetail: emergencyDetailController.text.toString(),
                lockBoxCode: lockboxCodeController.text.toString(),
                id: widget.projectDetailModel!.id
              )
          ).then((value) => {

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context)=>const HomeScreen()))

          });
        }



      }catch(e){

        setState(() {
          loading=false;
        });

        // ignore: use_build_context_synchronously
        showErrorPopUp(context, e.toString().contains("network")?"Check your Internet":"Something Went Wrong");

      }

    }
  }


}
