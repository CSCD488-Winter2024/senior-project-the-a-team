import 'package:flutter/material.dart';

import '../post_widgets/post.dart';
import '../post_widgets/post_body_box.dart';
import '../post_widgets/post_tag_box.dart';
import '../post_widgets/post_title_box.dart';
import 'job_wage_box.dart';

// ignore: must_be_immutable
class JobPost extends Post  {
  
  double wage;
  bool volunteer;
  String wageType;

  JobPost(
    {
    super.key, 
    required super.title, 
    required super.body, 
    required super.tags, 
    required super.header, 
    required super.user, 
    required super.interestCount, 
    required super.created, 
    required super.postId,
    this.volunteer = false,
    this.wageType = "",
    this.wage = 0.0,
    }
  );
 
  @override
  Widget build(BuildContext context) {
      // Create a list to hold the children of the Column
    int year = created.year;
    int month = created.month;
    int day = created.day;

    List<Widget> columnChildren = [      
      PostTitleBox(title: title),
      PostTagBox(tags: tags),
      PostBodyBox(body: body),
      Padding(padding: const EdgeInsets.all(15.0), child:Text("posted on: $month-$day-$year",
      textAlign: TextAlign.left,)
      ),
      JobWageBox(wageType: wageType, wage: wage)
    ]; 
      
    // Return the Column with all children
    return Column(
      children: columnChildren,
    );
  }
}

