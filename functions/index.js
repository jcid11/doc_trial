const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//


// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();
const express = require('express');
const cors = require('cors');
const app = express();
// Automatically allow cross-origin requests
app.use(cors({ origin: true }));

// Add middleware to authenticate requests


 app.get('/getUsers',async(req,res)=>{
const _firestore = admin.firestore();
const stuff = [];

   /*await _firestore.collection('User').get().then(snapshot => {
      const stuff = [];
      snapshot.forEach(doc => {
         var newelement = {
             "Name": JSON.parse(doc.id),
          }
          stuff = stuff.concat(newelement);
      });

       
    }).catch(reason => {
        res.send(reason)
   })*/

   const userQuery = await _firestore.collection('User').get();
      userQuery.forEach(doc => {
          stuff.push({
            "Name": doc.data().Name,
            "Email":doc.data().Email,
            "Age":doc.data().Age
         }); 
      });

       
    
   res.send(stuff)
   return "";
 });


 app.get('/getLoggedInUser',async(req,res)=>{
   const _firestore = admin.firestore();


      /*await _firestore.collection('User').get().then(snapshot => {
         const stuff = [];
         snapshot.forEach(doc => {
            var newelement = {
                "Name": JSON.parse(doc.id),
             }
             stuff = stuff.concat(newelement);
         });
   
          
       }).catch(reason => {
           res.send(reason)
      })*/
   
      const userQuery = await _firestore.collection('User').doc(req.query.id).get();
          
       
      res.send({Name:`${userQuery.data().Name}`,Email:`${userQuery.data().Email}`,Age:`${userQuery.data().Age}`})
      return "";
    });
   



 app.post('/registerUser',async(req,res)=>{
   const _firestore = admin.firestore();
     data = {
         "Name":req.body.Name,
         "Email":req.body.Email,
         "Age": req.body.Age
     }
     const writeFromApp= await _firestore.collection('User').doc(req.body.Email).set(data).then(snap=>{
        res.send({value:true,message:"Usuario ha sido creado exitosamente"})
     }).catch(reason => {
        res.send({value:false,message:"Usuario no creado correctamente",razon:reason})
   })
   return writeFromApp
 });

 exports.someMethod = functions.https.onRequest(async(req, res) => {
     const _firestore = admin.firestore();
    
     transictionData = {
         name:"ana",
         email:"ana@gmail.com"
     }
    /* res.status(200).json({ ok: true, msg: 'Creado correctamente' })*/
     const writeResult = await _firestore.collection('User').add(transictionData).then(snap=>{
       /*
        if(req.method=='POST'){
            res.send({value:true,message:"Post method"})
         }else{
            res.send({value:true,message:"Usuario creado correctamente"})
            return "";
         }
         */
         res.send({value:true,message:"Usuario creado correctamente"})
         return "";
     }).catch(reason => {
        res.send({value:false,message:"Usuario no creado correctamente"})
   })
        
     return writeResult
     /*
        await _firestore.collection('User').get().then(snapshot => {
                    snapshot.forEach(doc => {
                       var newelement = {
                            "id": doc.id,
                           "name": doc.data().name,
                        }
                        stuff = stuff.concat(newelement);
                    });
                      res.send(stuff)
                     return "";
                  }).catch(reason => {
                      res.send(reason)
                 })
                */
 });
 exports.widgets = functions.https.onRequest(app);
 