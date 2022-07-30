package com.brotherfolnciy.android_contacts_plugin

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware

import android.Manifest
import android.app.Activity
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import kotlinx.coroutines.*

import androidx.core.app.ActivityCompat

import android.content.pm.PackageManager

import androidx.core.content.ContextCompat

import android.os.Bundle
import contacts.core.Contacts
import contacts.core.ContactsFields
import contacts.core.asc
import contacts.core.util.*
import android.graphics.Bitmap

import android.util.Base64
import androidx.annotation.UiThread
import com.google.gson.GsonBuilder
import contacts.core.entities.Contact
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.io.ByteArrayOutputStream


/** AndroidContactsPlugin */
class AndroidContactsPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel

  private lateinit var context: Context
  private lateinit var activity: Activity

  override fun onDetachedFromActivity() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
    activity.requestPermissions(arrayOf(Manifest.permission.READ_CONTACTS), 1)
    readContacts()
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "brotherfolnciy.dev/android_contacts_plugin")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getContacts") {
      val permission: Boolean = activity.checkSelfPermission(Manifest.permission.READ_CONTACTS) == PackageManager.PERMISSION_GRANTED

      if(!permission){
        result.error("Error", "No permission to read contacts", "Allow read access to contacts for the plugin to work correctly")
      }else{
        val contacts = Contacts(context)
          .broadQuery()
          .orderBy(ContactsFields.DisplayNamePrimary.asc())
          .find()

        val gsonPretty = GsonBuilder().setPrettyPrinting().create()
        CoroutineScope(Dispatchers.Default).launch {
          val contactsItems = getContacts(
            contacts,
            context
          )

          result.success(gsonPretty.toJson(Response(contacts = contactsItems)))
        }
      }
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun getContacts(contacts : List<Contact>, context : Context) : List<ContactItem>{
    val contactItems = mutableListOf<ContactItem>()

    for (contact in contacts) {
      val encodedImage: String
      val bitmap = contact.photoBitmap(contacts = Contacts(context))

      encodedImage = if(bitmap != null){
        convert(contact.photoBitmap(contacts = Contacts(context))!!) ?: "DATA_MISSED"
      }else{
        "DATA_MISSED"
      }

      var name = "DATA_MISSED";
      var phones = listOf<String>();

      if(contact.names().toList().count() > 0) {
        name = contact.names().toList()[0].displayName ?: "DATA_MISSED"
      }

      if(contact.phones().toList().count() > 0) {
        phones = contact.phones().toList().map{it.number ?: "DATA_MISSED"}
      }

      val contactItem =
        ContactItem(name = name, phones = phones, imageBase64 = encodedImage)

      contactItems.add(contactItem)
    }

    return contactItems
  }
  
  private fun convert(bitmap: Bitmap): String? {
    val outputStream = ByteArrayOutputStream()
    bitmap.compress(Bitmap.CompressFormat.JPEG, 70, outputStream)
    return Base64.encodeToString(outputStream.toByteArray(), Base64.DEFAULT)
  }

  private fun readContacts(): Contacts {
    return Contacts(context)
  }
}

class Response(val contacts: List<ContactItem>)
{
  override fun toString(): String {
    return "Category [contacts: ${this.contacts}]"
  }
}

class ContactItem(
  val name: String?,
  val phones: List<String>?,
  val imageBase64: String?)
{
  override fun toString(): String {
    return "Category [name: ${this.name}, phones: ${this.phones}, imageBase64: ${this.imageBase64}]"
  }
}
