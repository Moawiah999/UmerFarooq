import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management/models/project_detail_model.dart';

class ProjectRepository{

  Future<void> addProject(ProjectDetailModel projectDetailModel) async {
    await FirebaseFirestore.instance.collection("projects").doc().set(
        projectDetailModel.toJson()
    );
  }

  Future<List<ProjectDetailModel>> retrieveProjects() async {
    List<ProjectDetailModel> projectDataList = [];
    await FirebaseFirestore.instance.collection("projects").orderBy(FieldPath.documentId).get().then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            projectDataList.add(ProjectDetailModel.fromJson(doc));
          }
    });

    return projectDataList;

  }

  Future<void> editProject(ProjectDetailModel projectDetailModel) async {

    await FirebaseFirestore.instance.collection("projects").doc(projectDetailModel.id).set(
        ProjectDetailModel(
          projectName: projectDetailModel.projectName,
          address: projectDetailModel.address,
          tenantName: projectDetailModel.tenantName,
          tenantPhone: projectDetailModel.tenantPhone,
          emergencyPersonName: projectDetailModel.emergencyPersonName,
          emergencyPersonPhone: projectDetailModel.emergencyPersonPhone,
          emergencyDetail: projectDetailModel.emergencyDetail,
          lockBoxCode: projectDetailModel.lockBoxCode,
        ).toJson()
    );
  }
  Future<void> deleteProject(ProjectDetailModel projectDetailModel) async {
    await FirebaseFirestore.instance.collection("projects").doc(projectDetailModel.id).delete();
  }


}