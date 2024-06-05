import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get helloWorld => 'Bonjour le monde !';

  @override
  String get refresh => 'refresh';

  @override
  String get back => 'back';

  @override
  String get menu => 'menu';

  @override
  String get ok => 'D\'accord';

  @override
  String get addtodo => 'add new todo';

  @override
  String get addassign => 'add new assignment';

  @override
  String get navigateright => 'navigate right';

  @override
  String get navigateleft => 'navigate left';

  @override
  String get success => 'Success';

  @override
  String get passwordlinksent => 'Password reset link has been sent to your email.';

  @override
  String get generic_error_prompt => 'Une erreur s\'est produite';

  @override
  String get generic_error_prompt1 => 'There was an error submitting your request, kindly check your internet connection or verify your credetials before submission.';

  @override
  String get login_error_cannot_find_user => 'Impossible de trouver un utilisateur avec les identifiants saisis';

  @override
  String get login_error_wrong_credentials => 'Mauvais identifiants';

  @override
  String get login => 'Connexion';

  @override
  String get letmein => 'Let me in';

  @override
  String get while_we_can => 'Tant que nous le pouvons';

  @override
  String get while_we_could => 'Tant que nous le pourrions';

  @override
  String get email_text_field_placeholder => 'Adresse e-mail';

  @override
  String get password_text_field_placeholder => 'Mot de passe';

  @override
  String get sign_up_instead => 'Inscrivez-vous plutôt ?';

  @override
  String get forgot_password => 'Mot de passe oublié ?';

  @override
  String get sign_up => 'S\'inscrire';

  @override
  String get signmeup => 'Sign me Up';

  @override
  String get internet_error => 'Erreur de connexion Internet';

  @override
  String get account_disable => 'Le compte est temporairement désactivé';

  @override
  String get weak_password => 'Mot de passe faible';

  @override
  String get email_already_in_use => 'Adresse e-mail déjà utilisée.';

  @override
  String get invalid_email => 'E-mail invalide.';

  @override
  String get password_mismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get confirm_password => 'Confirmez le mot de passe';

  @override
  String get login_instead => 'Connexion plutôt ?';

  @override
  String get verify_email => 'Vérifier l\'e-mail';

  @override
  String get verify_message => 'Un e-mail vous a été envoyé pour vérification. Veuillez cliquer sur le lien pour vérifier. Ensuite, veuillez vous connecter.\nCependant, si vous n\'avez pas reçu l\'e-mail, appuyez sur le bouton de renvoi ci-dessous pour renvoyer le lien.\n\nMerci.';

  @override
  String get resend_link => 'Renvoyer le lien';

  @override
  String get login_q => 'Se connecter ?';

  @override
  String get sign_upq => 'S\'inscrire ?';

  @override
  String get forgot_message => 'Entrez votre e-mail puis cliquez sur le bouton Réinitialiser ci-dessous. Un e-mail contenant le lien de réinitialisation vous sera envoyé.';

  @override
  String get reset_password => 'Réinitialiser le mot de passe';

  @override
  String get resetmypassword => 'Reset my password';

  @override
  String get home => 'Accueil';

  @override
  String get work => 'Travail';

  @override
  String get personal => 'Personnel';

  @override
  String get title => 'Titre';

  @override
  String get begin => 'Commencer';

  @override
  String get finish => 'Terminer';

  @override
  String get time => 'Temps';

  @override
  String get allday => 'Toute la journée';

  @override
  String get createalert => 'Créer une alerte';

  @override
  String get beforetime => 'avant l\'heure';

  @override
  String get cancel => 'Annuler';

  @override
  String get create => 'Créer';

  @override
  String get alert => 'Alerte';

  @override
  String get description => 'Description';

  @override
  String get attach => 'Joindre un fichier';

  @override
  String get incorrectdate => 'Format de date incorrect';

  @override
  String get second => 'seconde';

  @override
  String get minute => 'minute';

  @override
  String get hour => 'heure';

  @override
  String get day => 'jour';

  @override
  String get week => 'semaine';

  @override
  String get month => 'mois';

  @override
  String get once => 'once';

  @override
  String get daily => 'daily';

  @override
  String get weekly => 'weekly';

  @override
  String get monthly => 'monthly';

  @override
  String get titleEmpty => 'Le titre est requis';

  @override
  String get beginEmpty => 'L\'heure de début de la tâche est requise';

  @override
  String get finishEmpty => 'L\'heure de fin de la tâche est requise';

  @override
  String get delete => 'Supprimer';

  @override
  String get account => 'Compte';

  @override
  String get all => 'Tout';

  @override
  String get open => 'Ouvrir';

  @override
  String get closed => 'Fermé';

  @override
  String get archived => 'Archivé';

  @override
  String get diary => 'Journal';

  @override
  String get tasks => 'Tâches';

  @override
  String get abouttoday => 'À propos d\'aujourd\'hui ...';

  @override
  String task(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tâches',
      one: 'Tâche',
      zero: 'Pas encore de tâche',
    );
    return '$_temp0';
  }

  @override
  String get accountforthistask => 'Compte pour cette tâche...';

  @override
  String get markascompleted => 'Marquer comme terminé';

  @override
  String get stillneedswork => 'A encore besoin de travail ?';

  @override
  String get profile => 'Profil';

  @override
  String get notification => 'Notification';

  @override
  String get addnewcontact => 'Ajouter un nouveau contact';

  @override
  String get deletemyaccount => 'Supprimer mon compte';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get accountname => 'Nom du compte';

  @override
  String get accountemail => 'E-mail du compte';

  @override
  String get greaterthan3mb => 'L\'image sélectionnée est supérieure à 3 Mo.';

  @override
  String get addnewcontact2 => 'Ajouter un nouveau contact';

  @override
  String get search => 'Rechercher';

  @override
  String get couldnotfindContact => 'Désolé, ce contact n\'a pas pu être trouvé';

  @override
  String get pleasewaitamoment => 'Veuillez patienter un instant';

  @override
  String get synchronizing => 'Synchronisation';

  @override
  String get editContactName => 'Modifier le nom du contact';

  @override
  String get contactEmail => 'E-mail du contact';

  @override
  String get saveContact => 'Enregistrer le contact';

  @override
  String get jan => 'Jan';

  @override
  String get feb => 'Fév';

  @override
  String get mar => 'Mar';

  @override
  String get apr => 'Avr';

  @override
  String get may1 => 'Mai';

  @override
  String get jun => 'Jui';

  @override
  String get jul => 'Juil';

  @override
  String get aug => 'Aoû';

  @override
  String get sep => 'Sep';

  @override
  String get oct => 'Oct';

  @override
  String get nov => 'Nov';

  @override
  String get dec => 'Déc';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get set => 'Définir';

  @override
  String get assign => 'Attribuer';

  @override
  String get uploadingtocloud => 'Veuillez patienter, téléchargement des fichiers sur le cloud en cours.';

  @override
  String get message => 'Message';

  @override
  String get updateInfo => 'Mettre à jour les informations';

  @override
  String get hometowork => 'Ce contact existe déjà dans les contacts à domicile.\nLa poursuite déplacera ce contact des contacts à domicile aux contacts professionnels';

  @override
  String get hometowork2 => 'La poursuite déplacera ce contact des contacts à domicile aux contacts professionnels';

  @override
  String get worktohome => 'Ce contact existe déjà dans les contacts professionnels.\nLa poursuite déplacera ce contact des contacts professionnels aux contacts à domicile';

  @override
  String get worktohome2 => 'La poursuite déplacera ce contact des contacts professionnels aux contacts à domicile';

  @override
  String get contacts => 'Contacts';

  @override
  String get homecontact => 'Contacts à domicile';

  @override
  String get workcontact => 'Contacts professionnels';

  @override
  String get deleteinfo => 'Attention : La poursuite supprimera ce contact de façon permanente';

  @override
  String get update => 'Mettre à jour';

  @override
  String get save => 'Enregistrer';

  @override
  String get tdo => 'À faire';

  @override
  String get toaccount => 'Au Compte';

  @override
  String get todo => 'À faire';

  @override
  String get pending => 'En Attente';

  @override
  String get done => 'Fait';

  @override
  String get archive => 'Archiver';

  @override
  String get accept => 'Accepter';

  @override
  String get decline => 'Décliner';

  @override
  String get declined => 'Refusé';

  @override
  String get viewaccount => 'Voir le Compte';

  @override
  String get submit => 'Soumettre';

  @override
  String get completed => 'Terminé';

  @override
  String get underway => 'En Cours';

  @override
  String get needswork => 'Besoin de Travail?';

  @override
  String get markdone => 'Marquer comme Fait?';

  @override
  String get pendingapproval => 'En Attente d\'Approbation';

  @override
  String get filedoesnotexist => 'Le fichier n\'existe pas.';

  @override
  String get couldnotdeletefile => 'Erreur: Impossible de supprimer le fichier';

  @override
  String get deletefile => 'Attention: La poursuite supprimera ce fichier de façon permanente';

  @override
  String get deletetask => 'Attention: La poursuite supprimera cette tâche de façon permanente';

  @override
  String get calendar => 'Calendrier';

  @override
  String get deleteaccount => 'Supprimer le Compte';

  @override
  String get invalidcredentials => 'La suppression du compte a échoué, les informations d\'identification sont invalides';

  @override
  String get dailyassignlimit => 'La limite d\'attribution quotidienne est cinq';

  @override
  String get unabletofetchinternet => 'Impossible de récupérer les contacts.\nVeuillez vérifier votre connexion Internet';

  @override
  String get monday => 'Lundi';

  @override
  String get tuesday => 'Mardi';

  @override
  String get wednesday => 'Mercredi';

  @override
  String get thursday => 'Jeudi';

  @override
  String get friday => 'Vendredi';

  @override
  String get saturday => 'Samedi';

  @override
  String get sunday => 'Dimanche';

  @override
  String get tassign => '2-Assigner';

  @override
  String get eraseall => 'Avertissement ! Tout ce que vous avez recueilli sera effacé.\n\nIl s\'agit d\'une action irréversible, êtes-vous sûr de vouloir continuer ?';

  @override
  String get accountdelfailedinternet => 'Échec de la suppression du compte, veuillez vérifier votre connexion Internet';

  @override
  String get maximumcloudsize => 'Malheureusement, vous avez dépassé la taille maximale de téléchargement dans le cloud de 150 Ko';

  @override
  String get failedrequestinternet => 'Échec de la soumission de la demande.\nVeuillez vérifier votre connexion Internet';

  @override
  String get accountdoesnotexist => 'Échec de la demande\nCet utilisateur a peut-être supprimé son compte ou son compte a peut-être été suspendu';

  @override
  String get settimeperiod => 'Veuillez définir la période correcte. L\'heure de début ne peut pas être égale à ou après l\'heure de fin.';

  @override
  String get january => 'Janvier';

  @override
  String get february => 'Février';

  @override
  String get march => 'Mars';

  @override
  String get april => 'Avril';

  @override
  String get may => 'Mai';

  @override
  String get june => 'Juin';

  @override
  String get july => 'Juillet';

  @override
  String get august => 'Août';

  @override
  String get september => 'Septembre';

  @override
  String get october => 'Octobre';

  @override
  String get november => 'Novembre';

  @override
  String get december => 'Décembre';

  @override
  String get sun => 'DIM';

  @override
  String get mon => 'LUN';

  @override
  String get tue => 'MAR';

  @override
  String get wed => 'MER';

  @override
  String get thu => 'JEU';

  @override
  String get fri => 'VEN';

  @override
  String get sat => 'SAM';

  @override
  String get personalinfotodo => 'Créez vos tâches ici, elles apparaîtront sous forme de liste';

  @override
  String get calendarinfoyear => 'Appuyez sur l\'année ou faites défiler les années';

  @override
  String get calendarinfomonth => 'Appuyez sur le mois ou parcourez les mois';

  @override
  String get calendarinfodays => 'Appuyez sur la date de votre choix';

  @override
  String get calendarinfoweekss => 'Appuyez sur la semaine de votre choix';

  @override
  String get personalinfoaccount => 'Écrivez/voyez un compte rendu de vos tâches ou créez un journal';

  @override
  String get personalinfoassign => 'Attribuez des tâches à effectuer par d\'autres personnes de vos contacts';

  @override
  String get homeinfoassigned => 'Les tâches qui vous ont été assignées par vos contacts à domicile apparaîtront ici';

  @override
  String get workinfoassigned => 'Les tâches qui vous ont été assignées par vos contacts professionnels apparaîtront ici';

  @override
  String get disableInfo => 'Pour désactiver les astuces de votre application, \nappuyez sur l\'icône de profil. Dans le menu de profil qui apparaît. Basculez le menu des astuces sur \'off\'.';

  @override
  String get info => 'Info';

  @override
  String get hints => 'Activer les astuces';

  @override
  String get effectchanges => 'Pour effectuer ces modifications, l\'application redémarrera. Souhaitez-vous continuer?';
}
