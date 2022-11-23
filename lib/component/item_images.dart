
import 'package:flutter/material.dart';


class ItemImages extends StatefulWidget {
  const ItemImages({ Key? key, required this.imageProvide, required this.onpressedCamera, required this.onpressedGallery}) : super(key: key);
  final ImageProvider<Object> imageProvide;
  final Function()? onpressedCamera;
  final  Function()? onpressedGallery;

  @override
  State<ItemImages> createState() => _ItemImagesState();
}

class _ItemImagesState extends State<ItemImages> {

  
 
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                image: DecorationImage(
                  image: widget.imageProvide,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: -7.5,
              right: 4,
              child: IconButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Select Image'),
                    content: const Text(
                        'Select image from device gallery or use device camera'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: widget.onpressedCamera,
                        child: const Text('Camera'),
                      ),
                      TextButton(
                        onPressed: widget.onpressedGallery,
                        child: const Text('Gallery'),
                      ),
                    ],
                  ),
                ),
                icon: Icon(
                  Icons.add_a_photo_rounded,
                  size: 25,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}