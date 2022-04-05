import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

void showToast(String text) => BotToast.showText(text: text);

void showSuccessToast(String text) =>
    BotToast.showText(text: text, contentColor: Colors.green.withOpacity(0.7));

void showErrorToast(String text) =>
    BotToast.showText(text: text, contentColor: Colors.redAccent.withOpacity(0.7));

void showWarningToast(String text) =>
    BotToast.showText(text: text, contentColor: Colors.yellowAccent.withOpacity(0.7));


