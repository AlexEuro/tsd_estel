///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        margin:EdgeInsets.all(0),
        padding:EdgeInsets.all(0),
        width:MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color:Color(0x1f000000),
          shape:BoxShape.rectangle,
          borderRadius:BorderRadius.zero,
          border:Border.all(color:Color(0x4d9e9e9e),width:1),
        ),
        child:

        Column(
          mainAxisAlignment:MainAxisAlignment.start,
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisSize:MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin:EdgeInsets.all(0),
                padding:EdgeInsets.all(0),
                width:MediaQuery.of(context).size.width,
                height:100,
                decoration: BoxDecoration(
                  color:Color(0x1f000000),
                  shape:BoxShape.rectangle,
                  borderRadius:BorderRadius.zero,
                  border:Border.all(color:Color(0x4d9e9e9e),width:1),
                ),
                child:
                Text(
                  "Text",
                  textAlign: TextAlign.start,
                  overflow:TextOverflow.clip,
                  style:TextStyle(
                    fontWeight:FontWeight.w400,
                    fontStyle:FontStyle.normal,
                    fontSize:14,
                    color:Color(0xff000000),
                  ),
                ),
              ),
            ),
            Container(
              margin:EdgeInsets.all(0),
              padding:EdgeInsets.all(0),
              width:MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                color:Color(0x1f000000),
                shape:BoxShape.rectangle,
                borderRadius:BorderRadius.zero,
                border:Border.all(color:Color(0x4d9e9e9e),width:1),
              ),
              child:
              TextField(
                controller:TextEditingController(),
                obscureText:false,
                textAlign:TextAlign.start,
                maxLines:1,
                style:TextStyle(
                  fontWeight:FontWeight.w400,
                  fontStyle:FontStyle.normal,
                  fontSize:14,
                  color:Color(0xff000000),
                ),
                decoration:InputDecoration(
                  disabledBorder:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(4.0),
                    borderSide:BorderSide(
                        color:Color(0xff000000),
                        width:1
                    ),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(4.0),
                    borderSide:BorderSide(
                        color:Color(0xff000000),
                        width:1
                    ),
                  ),
                  enabledBorder:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(4.0),
                    borderSide:BorderSide(
                        color:Color(0xff000000),
                        width:1
                    ),
                  ),
                  hintText:"Enter Text",
                  hintStyle:TextStyle(
                    fontWeight:FontWeight.w400,
                    fontStyle:FontStyle.normal,
                    fontSize:14,
                    color:Color(0xff000000),
                  ),
                  filled:true,
                  fillColor:Color(0xfff2f2f3),
                  isDense:false,
                  contentPadding:EdgeInsets.symmetric(vertical: 8,horizontal:12),
                ),
              ),
            ),
          ],),
      ),
    )
    ;}
}