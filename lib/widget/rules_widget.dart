import 'package:flutter/material.dart';
import 'package:urban_spot/model/rules.dart';

Widget RulesWidget(
    BuildContext context, String img, String title, List<RulesModel> rm) {
  return Stack(
    children: [
      Container(),
      Container(
        height: 300.0,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover)),
      ),
      Container(
        height: 300,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.deepPurple,
              Colors.blue.withOpacity(0.2),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      Positioned(
        top: 250,
        left: 0,
        bottom: 0,
        right: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: Colors.white,
          ),
          child: rm.length > 0
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: rm.length,
              itemBuilder: (context, index) {
                return index % 2 == 1
                    ? Row(
                  children: [
                    Container(
                      width:
                      MediaQuery.of(context).size.width * 0.5 -
                          16,
                      alignment: Alignment.center,
                      child: Image(
                        image: AssetImage(
                          rm[index].image,
                        ),
                        width: MediaQuery.of(context).size.width * 0.25,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            rm[index].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(height: 5),
                          Text(
                            rm[index].text,
                            textAlign: TextAlign.justify,
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(8),
                      width:
                      MediaQuery.of(context).size.width * 0.5 -
                          16,
                    ),
                  ],
                )
                    : Row(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text(
                            rm[index].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(height: 5),
                          Text(
                            rm[index].text,
                            textAlign: TextAlign.justify,
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(8),
                      width:
                      MediaQuery.of(context).size.width * 0.5 -
                          16,
                    ),
                    Container(
                      width:
                      MediaQuery.of(context).size.width * 0.5 -
                          16,
                      alignment: Alignment.center,
                      child: Image(
                        image: AssetImage(
                          rm[index].image,
                        ),
                        width: MediaQuery.of(context).size.width * 0.25,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                );
              },
            ),
          )
              : Container(),
        ),
      ),
      AppTop(context),
    ],
  );
}

Widget AppTop(BuildContext context) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
    ),
  );
}