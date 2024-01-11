import 'package:bai5_bloc_dio/models/story_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class StoryComponent extends StatefulWidget {
  final Story story;
  const StoryComponent({super.key, required this.story});

  @override
  State<StoryComponent> createState() => _StoryComponentState();
}

class _StoryComponentState extends State<StoryComponent> {
  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.tryParse(widget.story.modifiedAt);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Container(
              height: 130,
              width: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border(bottom: BorderSide(width: 1)),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.story.image))),
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/news.svg',
                    height: 35,
                    width: 35,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(children: [
                Text(
                  widget.story.title,
                  style: const TextStyle(
                      fontFamily: 'Open Sans',
                      color: Color.fromRGBO(29, 26, 97, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.story.summary,
                  maxLines: 2,
                  style: const TextStyle(
                      fontFamily: 'Open Sans',
                      color: Color.fromRGBO(29, 26, 97, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    DateFormat('MMM d, y').format(dateTime!),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontFamily: 'Open Sans',
                        color: Color.fromRGBO(29, 26, 97, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
