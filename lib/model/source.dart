import 'package:flutter/material.dart';

/*
    This class handles the headlines of the selected news site
    @id is the id of the news site
    @name is the name of the news site
    @description is the short explanation of the news site
    @url is the link to the news site
 */

class Source{
  String id;
  String name;
  String description;
  String url;
  String category;

  Source(this.id, this.name, this.description, this.url, this.category);

}

class InnerSource{
  String id;
  String name;

  InnerSource(this.id, this.name);
}

 /*
    This class handles the headlines of the selected news site
    @title is the title of the headline
    @description is the short information on the news
    @url is the link to the precise headline
    @urlToImage is one the images about the headline
    @publishedAt is the date and time published
 */

class Articles{
  InnerSource source;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;

  Articles(this.source, this.title, this.description, this.url,
      this.urlToImage, this.publishedAt);


}

