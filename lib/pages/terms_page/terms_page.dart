import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moneypros/resources/strings/app_strings.dart';
import 'package:moneypros/style/app_colors.dart';
import 'package:moneypros/style/spacing.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsPage extends StatefulWidget {
  final title;

  const TermsPage({Key key, this.title}) : super(key: key);
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  String _crifTitle = "MoneyPros Terms for Credit Information Report";
  String _refundTitle = "";
  String _privacyTitle = "";
  String _termsTitle = "";
  String _crifTerms = "<div class=\"row\">" +
      "<p>Salasar Fintech Private Limited operate mobile applications and website <a href=\"https://www.moneypro-s.com\">https://www.moneypro-s.com</a> under brand names MoneyPros.</p>" +
      "<p>MoneyPros enables you to track, save and earn extra by automatically bringing your entire financial life across investments, loans, credit cards &amp; taxes, all in one app. (hereinafter referred to as “Services” or “Application”)</p>" +
      "<p>By continuing, you acknowledge that you have read and understood the below-mentioned MoneyPros Terms for Credit Information Report (“Terms”), the Terms and Conditions and the Privacy Policy of MoneyPros, and you hereby accept and agree to the same.</p>" +
      "<p>By using our Services, you, specifically agree and accept to be bound by the following:</p>" +
      "<p>1. You accept and agree that you are providing \"your express consent\” to MoneyPros to collect, receive, obtain, and/or fetch on your behalf, a copy of your credit score and credit information report from CRIF High Mark as your lawful and duly authorised/ appointed agent, at any time for so long as you continue to use our Services. You also agree to execute authorization/ consent in the format given in \“ Annexure A \” or in such other format as may be provided by MoneyPros from time to time.</p>" +
      "<p>2. You hereby accept and agree that the information provided to you by MoneyPros is based on your credit score and credit information report provided by CRIF High Mark. Accordingly, the information provided to you is on “As Is” and “As Available” basis. Please note that MoneyPros does not control your credit score, which is a statistical analysis of information contained in your credit file as maintained in the system and database of CRIF High Mark, and we cannot change that information for you. Neither does MoneyPros guarantee the timeliness, accuracy or correctness of any information contained in your credit score and/or credit information report nor shall it accept any liability, whatsoever, for any errors, inaccuracies or omissions in your credit score and/or credit information report or any information provided to you, basis your credit score and credit information report.</p>" +
      "<p>3. You agree that you shall not hold MoneyPros responsible or liable for any loss, claim, liability, or damage of any kind resulting from, arising out of, or in any way related to the delivery of your credit score and credit information report. MoneyPros agrees to protect and keep confidential your credit score and credit information report.</p>" +
      "<p>4. If you believe that any information in your credit information report is inaccurate and is affecting your score, you may dispute the same by directly contacting CRIF High Mark (<a href=\"https://www.crifhighmark.com/\">https://www.crifhighmark.com/</a>). </p>" +
      "</div>";
  String _refundData = "<div class=\"row\">" +
      "<p><b>MONEYPRO-S reserves the right to refuse/cancel a membership in any of MONEYPRO-S websites and mobile apps. The following policy applies to both MONEYPRO-S Websites and Mobile apps.</b></p>" +
      "<p><b>If MONEYPRO-S refuses a new or renewing membership, users will be offered a refund.</b></p>" +
      "<p><b>This policy is a part of the terms of usage of MONEYPRO-S website and mobile apps. The detailed terms are available at <a href=\"www.moneypro-s.com\">www.moneypro-s.com</a></b></p>" +
      "<p><b>Cancellation by user</b></p>" +
      "<p>User cancellations received within 2 days of registration may be eligible to receive a full refund .However, other purchases are non refundable.</p>" +
      "<p>Cancellations received after the stated deadline will not be eligible for a refund.</p>" +
      "<p>Cancellations will be accepted via e-mail at _info@moneypro-s.com, and must be received within the stated cancellation deadline.</p>" +
      "<p>All refund requests must be made by the user</p>" +
      "<p>Refund requests must include the username, contact no. of the user and the invoice number against which refund is sought.</p>" +
      "<p>Refunds will be credited back to the original credit card used for payment.</p>" +
      "<p>These above policies apply to all MONEYPRO-S websites unless otherwise specified in the corresponding website.</p>" +
      "</div>";

  String _privacyData =
      "1. Representations or warranties of any kind, express or implied about the completeness, accuracy, reliability, suitability or availability with respect to the website or the information, products, services or related graphics contained on the website for any purpose. Any reliance you place on such material is therefore strictly at your own risk.\n\n2. Termination:\n(i) By Salasar: Salasar may modify, suspend, or terminate access to, all or any portion of the Website at any time for any reason.\n(ii) By you: If you wish to terminate these Terms, you may immediately stop accessing or using this Website at any time.\n(iii) Automatic upon breach: Your access to, and use of, the Website may be terminated by Salasar automatically upon your breach of any of these Terms.\n(iv) Survival: The disclaimer of warranties, the limitation of liability, and the jurisdiction and applicable law provisions shall survive any termination of these Terms.\n3. Indemnification: You agree to indemnify, defend, and hold harmless Salasar and its officers, directors, agents, and employees (each, an “Indemnitee“) from and against any and all liabilities, damages, losses, expenses, claims, demands, suits, fines, or judgments (each, a “Claim” and collectively, “the Claims“), which may be suffered by, incurred by, accrued against, charged to, or recoverable from any Indemnitee, by reason of any Claim arising out of or in connection with (i) your use of and access to this Website; (ii) your violation of any term of these Terms; or (iii) your violation of any Salasar copyright, trademark or other Intellectual Property Right.\n4. Disclaimer of Warranties: The website and all information, content, materials, products and services included on or otherwise made available to you through the website (collectively, the \"contents\") are provided by Salasar on an \"as is,\" \"as available\" basis, without representations or warranties of any kind. Salasar makes no representations or warranties of any kind, express or implied, as to the operation of the website, the accuracy or completeness of the contents and the accuracy of the information. Salasar shall have no responsibility for any damage to your computer system or loss of data that results from the download of any content, materials, document or information. You expressly agree that your use of this website is at your sole risk. Salasar will not be liable for any damages of any kind arising from the use of this website or the contents including, without Limitation, direct, indirect, consequential, punitive, and consequential damages, unless otherwise specified in writing. To the full extent permitted by law, Salasar disclaims any and all representations and warranties with respect to the website and its contents, whether express or implied, including, without limitation, warranties of title, merchantability, and fitness for a particular purpose or use.\n5. Limitation of Liability: In no event shall Salasar, its directors, employees, agents or marketing contractor, be liable to you for any direct, indirect, incidental, special, punitive, or consequential damages whatsoever resulting from any (i) errors, mistakes, or inaccuracies of content; (ii) personal injury or property damage, of any nature whatsoever, resulting from your access to and use of our site; (iii) any unauthorized access to or use of our secure servers and/or any and all personal and/or business and/or financial information stored therein; (iv) any interruption or cessation of transmission to or from the website; (v) any bugs, viruses, trojan horses, or the like, which may be transmitted to or through the website by any third party; and/or (vi) any errors or omissions in any content or for any loss or damage of any kind incurred as a result of your use of any content posted, emailed, transmitted, or otherwise made available via this website, whether based on warranty, contract, tort, or any other legal theory, and whether or not Salasar is advised of the possibility of such damages.\nGoverning Law and Resolution of Disputes: These Terms shall be governed by and interpreted in accordance with the laws of India. In the event of any dispute arising out of these Terms the same shall be settled by a binding arbitration conducted by a sole arbitrator, appointed jointly by both Parties and governed by the Arbitration and Conciliation Act, 1996. The venue of arbitration shall be Mumbai, Maharashtra, India";

  String _termsData =
      "1. Representations or warranties of any kind, express or implied about the completeness, accuracy, reliability, suitability or availability with respect to the website or the information, products, services or related graphics contained on the website for any purpose. Any reliance you place on such material is therefore strictly at your own risk.\n\n2. Termination:\n(i) By Salasar: Salasar may modify, suspend, or terminate access to, all or any portion of the Website at any time for any reason.\n(ii) By you: If you wish to terminate these Terms, you may immediately stop accessing or using this Website at any time.\n(iii) Automatic upon breach: Your access to, and use of, the Website may be terminated by Salasar automatically upon your breach of any of these Terms.\n(iv) Survival: The disclaimer of warranties, the limitation of liability, and the jurisdiction and applicable law provisions shall survive any termination of these Terms.\n3. Indemnification: You agree to indemnify, defend, and hold harmless Salasar and its officers, directors, agents, and employees (each, an “Indemnitee“) from and against any and all liabilities, damages, losses, expenses, claims, demands, suits, fines, or judgments (each, a “Claim” and collectively, “the Claims“), which may be suffered by, incurred by, accrued against, charged to, or recoverable from any Indemnitee, by reason of any Claim arising out of or in connection with (i) your use of and access to this Website; (ii) your violation of any term of these Terms; or (iii) your violation of any Salasar copyright, trademark or other Intellectual Property Right.\n4. Disclaimer of Warranties: The website and all information, content, materials, products and services included on or otherwise made available to you through the website (collectively, the \"contents\") are provided by Salasar on an \"as is,\" \"as available\" basis, without representations or warranties of any kind. Salasar makes no representations or warranties of any kind, express or implied, as to the operation of the website, the accuracy or completeness of the contents and the accuracy of the information. Salasar shall have no responsibility for any damage to your computer system or loss of data that results from the download of any content, materials, document or information. You expressly agree that your use of this website is at your sole risk. Salasar will not be liable for any damages of any kind arising from the use of this website or the contents including, without Limitation, direct, indirect, consequential, punitive, and consequential damages, unless otherwise specified in writing. To the full extent permitted by law, Salasar disclaims any and all representations and warranties with respect to the website and its contents, whether express or implied, including, without limitation, warranties of title, merchantability, and fitness for a particular purpose or use.\n5. Limitation of Liability: In no event shall Salasar, its directors, employees, agents or marketing contractor, be liable to you for any direct, indirect, incidental, special, punitive, or consequential damages whatsoever resulting from any (i) errors, mistakes, or inaccuracies of content; (ii) personal injury or property damage, of any nature whatsoever, resulting from your access to and use of our site; (iii) any unauthorized access to or use of our secure servers and/or any and all personal and/or business and/or financial information stored therein; (iv) any interruption or cessation of transmission to or from the website; (v) any bugs, viruses, trojan horses, or the like, which may be transmitted to or through the website by any third party; and/or (vi) any errors or omissions in any content or for any loss or damage of any kind incurred as a result of your use of any content posted, emailed, transmitted, or otherwise made available via this website, whether based on warranty, contract, tort, or any other legal theory, and whether or not Salasar is advised of the possibility of such damages.\nGoverning Law and Resolution of Disputes: These Terms shall be governed by and interpreted in accordance with the laws of India. In the event of any dispute arising out of these Terms the same shall be settled by a binding arbitration conducted by a sole arbitrator, appointed jointly by both Parties and governed by the Arbitration and Conciliation Act, 1996. The venue of arbitration shall be Mumbai, Maharashtra, India";

  _getPolicyHtml() {
    return "<div class=\"row\">" +
        "<p>1. Representations or warranties of any kind, express or implied about the completeness, accuracy, reliability, suitability or availability with respect to the website or the information, products, services or related graphics contained on the website for any purpose. Any reliance you place on such material is therefore strictly at your own risk.</p>" +
        "<p>2. <b>Termination:</b></p>" +
        "<p>(i) <b>By Salasar:</b> Salasar may modify, suspend, or terminate access to, all or any portion of the Website at any time for any reason.</p>" +
        "<p>(ii) <b>By you:</b> If you wish to terminate these Terms, you may immediately stop accessing or using this Website at any time.</p>" +
        "<p>(iii) <b>Automatic upon breach:</b> Your access to, and use of, the Website may be terminated by Salasar automatically upon your breach of any of these Terms.</p>" +
        "<p>(iv) <b>Survival:</b> The disclaimer of warranties, the limitation of liability, and the jurisdiction and applicable law provisions shall survive any termination of these Terms.</p>" +
        "<p>3. <b>Indemnification:</b> You agree to indemnify, defend, and hold harmless Salasar and its officers, directors, agents, and employees (each, an “Indemnitee“) from and against any and all liabilities, damages, losses, expenses, claims, demands, suits, fines, or judgments (each, a “Claim” and collectively, “the Claims“), which may be suffered by, incurred by, accrued against, charged to, or recoverable from any Indemnitee, by reason of any Claim arising out of or in connection with (i) your use of and access to this Website; (ii) your violation of any term of these Terms; or (iii) your violation of any Salasar copyright, trademark or other Intellectual Property Right.</p>" +
        "<p>4. <b>Disclaimer of Warranties:</b> The website and all information, content, materials, products and services included on or otherwise made available to you through the website (collectively, the \"contents\") are provided by Salasar on an \"as is,\" \"as available\" basis, without representations or warranties of any kind. Salasar makes no representations or warranties of any kind, express or implied, as to the operation of the website, the accuracy or completeness of the contents and the accuracy of the information. Salasar shall have no responsibility for any damage to your computer system or loss of data that results from the download of any content, materials, document or information. You expressly agree that your use of this website is at your sole risk. Salasar will not be liable for any damages of any kind arising from the use of this website or the contents including, without Limitation, direct, indirect, consequential, punitive, and consequential damages, unless otherwise specified in writing. To the full extent permitted by law, Salasar disclaims any and all representations and warranties with respect to the website and its contents, whether express or implied, including, without limitation, warranties of title, merchantability, and fitness for a particular purpose or use.</p>" +
        "<p>5. <b>Limitation of Liability:</b> In no event shall Salasar, its directors, employees, agents or marketing contractor, be liable to you for any direct, indirect, incidental, special, punitive, or consequential damages whatsoever resulting from any (i) errors, mistakes, or inaccuracies of content; (ii) personal injury or property damage, of any nature whatsoever, resulting from your access to and use of our site; (iii) any unauthorized access to or use of our secure servers and/or any and all personal and/or business and/or financial information stored therein; (iv) any interruption or cessation of transmission to or from the website; (v) any bugs, viruses, trojan horses, or the like, which may be transmitted to or through the website by any third party; and/or (vi) any errors or omissions in any content or for any loss or damage of any kind incurred as a result of your use of any content posted, emailed, transmitted, or otherwise made available via this website, whether based on warranty, contract, tort, or any other legal theory, and whether or not Salasar is advised of the possibility of such damages.</p>" +
        "<p><b>Governing Law and Resolution of Disputes:</b> These Terms shall be governed by and interpreted in accordance with the laws of India. In the event of any dispute arising out of these Terms the same shall be settled by a binding arbitration conducted by a sole arbitrator, appointed jointly by both Parties and governed by the Arbitration and Conciliation Act, 1996. The venue of arbitration shall be Mumbai, Maharashtra, India</p>" +
        "</div>";
  }

  _getView() {
    String title;
    double size;
    String desc;

    switch (widget.title) {
      case AppStrings.termsOfUse:
        title = "";
        size = 0;
        desc = _getPolicyHtml();
        break;
      case AppStrings.privacyPolicy:
        title = "";
        size = 0;
        desc = _getPolicyHtml();
        ;
        break;
      case AppStrings.refundPolicy:
        title = _refundTitle;
        size = 0;
        desc = _refundData;
        break;
      case AppStrings.crifTerms:
        title = _crifTitle;
        size = 15;
        desc = _crifTerms;
        break;
    }

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          textScaleFactor: 1.1,
          style: TextStyle(
              color: AppColors.blackGrey, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: size),
        Html(data: desc,
        onLinkTap: (String url)async{
          await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
        },
        ),
        // Text(desc, style: TextStyle(color: AppColors.grey800, fontSize: 13))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: AppColors.blackGrey)),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.defaultMargin,
                  vertical: Spacing.smallMargin),
              child: _getView()),
        ),
      ),
    );
  }
}
