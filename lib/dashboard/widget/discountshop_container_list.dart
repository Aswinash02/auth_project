import 'package:flutter/material.dart';

class DiscountContainerList extends StatelessWidget {
  const DiscountContainerList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index){
            return discountContainer();
          }),
    );
  }
  Widget discountContainer(){
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15)),
        height: 170,
        width: 155,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '20% Discount',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text('Order any food from app and get the dicount',style: TextStyle(color: Colors.white),),
                ],
              ),

              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Show Now'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
