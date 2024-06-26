import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_beauty_salon_booking/components/home_upper_page.dart';
import 'package:flutter_beauty_salon_booking/components/my_app_bar.dart';
import 'package:flutter_beauty_salon_booking/components/salonspec.dart';
import 'package:flutter_beauty_salon_booking/logic/datetime_utilities.dart';
import 'package:flutter_beauty_salon_booking/models/booking_model.dart';
import 'package:flutter_beauty_salon_booking/models/services_model.dart';
import 'package:flutter_beauty_salon_booking/models/time_slot_model.dart';
import 'package:flutter_beauty_salon_booking/models/users_model.dart';
import 'package:flutter_beauty_salon_booking/providers/booking_provider.dart';
import 'package:flutter_beauty_salon_booking/providers/service_provider.dart';
import 'package:flutter_beauty_salon_booking/providers/time_slot_provider.dart';
import 'package:flutter_beauty_salon_booking/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ManagerHomePage extends StatefulWidget {
   ManagerHomePage({super.key});

  @override
  State<ManagerHomePage> createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  @override
  Widget build(BuildContext context) {
    List<String> serviceIds = [];
    List<String>userIds = [];
    List<String>timeSlotIds = [];


        List <Booking> bookingFetched = Provider.of<BookingProvider>(context).booking;
 
   
    for(Booking booking in bookingFetched){
      serviceIds.add(booking.serviceId);
      userIds.add(booking.customerId);
      timeSlotIds.add(booking.timeSlotId);


    }
   
   
    Provider.of<ServiceProvider>(context).setServicesByListIds(serviceIds);
    Provider.of<UserProvider>(context).setUsersByListOfIds(userIds);
    Provider.of<TimeSlotProvider>(context).setTimeSlotByListOfIds(timeSlotIds);
    List<Service> bookedService = Provider.of<ServiceProvider>(context).servicesByListIds;
    List<UserModel> usersBooked = Provider.of<UserProvider>(context).usersByListOfIds;
    List<TimeSlot> bookedTimeSlot = Provider.of<TimeSlotProvider>(context).timeSlotByListOfIds;
     int minListLength = min(bookingFetched.length, min(bookedService.length, min(usersBooked.length, bookedTimeSlot.length)));
  
  
        return   bookingFetched.isEmpty? Center(child: CircularProgressIndicator())
        :Scaffold(
          appBar: MyAppBar(),
          body: SingleChildScrollView(
           child:  Column(
      children: [

     SizedBox(child: HomeUpper()),
     SalonSpec(),
     Center(child: Text("Booked Services ",style:Theme.of(context).textTheme.bodyLarge,),),
        Positioned.fill(
          child: SizedBox(
            height: 500,
            child: ListView.builder(
            
              itemCount: minListLength,
              itemBuilder: (context, index) {
                var service = bookedService[index];
                var timeSlot = bookedTimeSlot[index];
                var user = usersBooked[index];
        
            
                    return ListTile(
                     

                         leading: CircleAvatar(
        backgroundImage: NetworkImage(service.photo), // Load image from URL
      ),
                       title:  Text(service.name,style: Theme.of(context).textTheme.bodyLarge),
                 
                       subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        
                       Text('Duration: ${service.duration}',style: Theme.of(context).textTheme.bodyMedium),
                       Text('Price: \$${service.price}' ,style: Theme.of(context).textTheme.bodyMedium),
                 // Text('  booked for ${timeSlot.startTime} - ${timeSlot.endTime}'),
                  Text('Booked for ${DateTimeUtils.formatDateTime(timeSlot.startTime)} - ${timeSlot.endTime.hour}: ${timeSlot.endTime.minute}${timeSlot.endTime.second}',style: Theme.of(context).textTheme.bodyMedium),
   Text('Booked by ${user.firstName} ${user.lastName}',style: Theme.of(context).textTheme.bodyMedium),
   Text("phone Number  ${user.phoneNumber}",style: Theme.of(context).textTheme.bodyMedium),

                      
            ] ));

               
              },
            ),))])
       
 )
 ); }}



      