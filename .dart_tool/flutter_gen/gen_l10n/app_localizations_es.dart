import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get helloWorld => '¡Hola Mundo!';

  @override
  String get refresh => 'refresh';

  @override
  String get back => 'back';

  @override
  String get menu => 'menu';

  @override
  String get ok => 'Ok';

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
  String get generic_error_prompt => 'Ocurrió un error';

  @override
  String get generic_error_prompt1 => 'There was an error submitting your request, kindly check your internet connection or verify your credetials before submission.';

  @override
  String get login_error_cannot_find_user => 'No se puede encontrar un usuario con las credenciales ingresadas';

  @override
  String get login_error_wrong_credentials => 'Credenciales incorrectas';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get letmein => 'Let me in';

  @override
  String get while_we_can => 'Mientras podamos';

  @override
  String get while_we_could => 'Mientras pudimos';

  @override
  String get email_text_field_placeholder => 'Dirección de correo electrónico';

  @override
  String get password_text_field_placeholder => 'Contraseña';

  @override
  String get sign_up_instead => '¿Registrarse en su lugar?';

  @override
  String get forgot_password => '¿Olvidó su contraseña?';

  @override
  String get sign_up => 'Registrarse';

  @override
  String get signmeup => 'Sign me Up';

  @override
  String get internet_error => 'Error de conexión a Internet';

  @override
  String get account_disable => 'La cuenta está temporalmente desactivada';

  @override
  String get weak_password => 'Contraseña débil';

  @override
  String get email_already_in_use => 'Correo electrónico ya en uso.';

  @override
  String get invalid_email => 'Correo electrónico inválido.';

  @override
  String get password_mismatch => 'Las contraseñas no coinciden';

  @override
  String get confirm_password => 'Confirmar contraseña';

  @override
  String get login_instead => '¿Iniciar sesión en su lugar?';

  @override
  String get verify_email => 'Verificar correo electrónico';

  @override
  String get verify_message => 'Se ha enviado un correo electrónico para su verificación. Por favor, haga clic en el enlace para verificar. Luego, proceda a iniciar sesión.\nSin embargo, si no ha recibido el correo electrónico, presione el botón de reenviar a continuación para volver a enviar el enlace.\n\nGracias.';

  @override
  String get resend_link => 'Reenviar enlace';

  @override
  String get login_q => '¿Iniciar sesión?';

  @override
  String get sign_upq => '¿Registrarse?';

  @override
  String get forgot_message => 'Ingrese su correo electrónico y luego haga clic en el botón Restablecer a continuación. Se le enviará un correo electrónico con el enlace de restablecimiento.';

  @override
  String get reset_password => 'Restablecer contraseña';

  @override
  String get resetmypassword => 'Reset my password';

  @override
  String get home => 'Inicio';

  @override
  String get work => 'Trabajo';

  @override
  String get personal => 'Personal';

  @override
  String get title => 'Título';

  @override
  String get begin => 'Inicio';

  @override
  String get finish => 'Fin';

  @override
  String get time => 'Tiempo';

  @override
  String get allday => 'Todo el día';

  @override
  String get createalert => 'Crear alerta';

  @override
  String get beforetime => 'antes de la hora';

  @override
  String get cancel => 'Cancelar';

  @override
  String get create => 'Crear';

  @override
  String get alert => 'Alerta';

  @override
  String get description => 'Descripción';

  @override
  String get attach => 'Adjuntar un archivo';

  @override
  String get incorrectdate => 'Formato de fecha incorrecto';

  @override
  String get second => 'segundo';

  @override
  String get minute => 'minuto';

  @override
  String get hour => 'hora';

  @override
  String get day => 'día';

  @override
  String get week => 'semana';

  @override
  String get month => 'mes';

  @override
  String get once => 'once';

  @override
  String get daily => 'daily';

  @override
  String get weekly => 'weekly';

  @override
  String get monthly => 'monthly';

  @override
  String get titleEmpty => 'El título es requerido';

  @override
  String get beginEmpty => 'Se requiere la hora de inicio de la tarea';

  @override
  String get finishEmpty => 'Se requiere la hora de finalización de la tarea';

  @override
  String get delete => 'Eliminar';

  @override
  String get account => 'Cuenta';

  @override
  String get all => 'Todo';

  @override
  String get open => 'Abierto';

  @override
  String get closed => 'Cerrado';

  @override
  String get archived => 'Archivado';

  @override
  String get diary => 'Diario';

  @override
  String get tasks => 'Tareas';

  @override
  String get abouttoday => 'Acerca de hoy...';

  @override
  String task(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tareas',
      one: 'Tarea',
      zero: 'Sin tareas aún',
    );
    return '$_temp0';
  }

  @override
  String get accountforthistask => 'Cuenta para esta tarea...';

  @override
  String get markascompleted => 'Marcar como completado';

  @override
  String get stillneedswork => '¿Todavía necesita trabajo?';

  @override
  String get profile => 'Perfil';

  @override
  String get notification => 'Notificación';

  @override
  String get addnewcontact => 'Agregar nuevo contacto';

  @override
  String get deletemyaccount => 'Eliminar mi cuenta';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get accountname => 'Nombre de la cuenta';

  @override
  String get accountemail => 'Correo electrónico de la cuenta';

  @override
  String get greaterthan3mb => 'La imagen seleccionada es mayor que 3Mb.';

  @override
  String get addnewcontact2 => 'Agregar Nuevo Contacto';

  @override
  String get search => 'Buscar';

  @override
  String get couldnotfindContact => 'Lo siento, no sepudo encontrar ese contacto';

  @override
  String get pleasewaitamoment => 'Por favor espere un momento';

  @override
  String get synchronizing => 'Sincronizando';

  @override
  String get editContactName => 'Editar Nombre de Contacto';

  @override
  String get contactEmail => 'Correo electrónico del contacto';

  @override
  String get saveContact => 'Guardar Contacto';

  @override
  String get jan => 'Ene';

  @override
  String get feb => 'Feb';

  @override
  String get mar => 'Mar';

  @override
  String get apr => 'Abr';

  @override
  String get may1 => 'May';

  @override
  String get jun => 'Jun';

  @override
  String get jul => 'Jul';

  @override
  String get aug => 'Ago';

  @override
  String get sep => 'Sep';

  @override
  String get oct => 'Oct';

  @override
  String get nov => 'Nov';

  @override
  String get dec => 'Dic';

  @override
  String get today => 'Hoy';

  @override
  String get set => 'Establecer';

  @override
  String get assign => 'Asignar';

  @override
  String get uploadingtocloud => 'Espere, subiendo archivos a la nube.';

  @override
  String get message => 'Mensaje';

  @override
  String get updateInfo => 'Actualizar Información';

  @override
  String get hometowork => 'Este contacto ya existe en los contactos de casa.\nProcederá a mover este contacto de los contactos de casa a los contactos de trabajo';

  @override
  String get hometowork2 => 'Procederá a mover este contacto de los contactos de casa a los contactos de trabajo';

  @override
  String get worktohome => 'Este contacto ya existe en los contactos de trabajo.\nProcederá a mover este contacto de los contactos de trabajo a los contactos de casa';

  @override
  String get worktohome2 => 'Procederá a mover este contacto de los contactos de trabajo a los contactos de casa';

  @override
  String get contacts => 'Contactos';

  @override
  String get homecontact => 'Contactos de Casa';

  @override
  String get workcontact => 'Contactos de Trabajo';

  @override
  String get deleteinfo => 'Advertencia: procederá a eliminar este contacto permanentemente';

  @override
  String get update => 'Actualizar';

  @override
  String get save => 'Guardar';

  @override
  String get tdo => '2-Hacer';

  @override
  String get toaccount => '2-Cuenta';

  @override
  String get todo => 'Por Hacer';

  @override
  String get pending => 'Pendiente';

  @override
  String get done => 'Hecho';

  @override
  String get archive => 'Archivo';

  @override
  String get accept => 'Aceptar';

  @override
  String get decline => 'Rechazar';

  @override
  String get declined => 'Rechazado';

  @override
  String get viewaccount => 'Ver Cuenta';

  @override
  String get submit => 'Enviar';

  @override
  String get completed => 'Completado';

  @override
  String get underway => 'En Curso';

  @override
  String get needswork => '¿Necesita trabajo?';

  @override
  String get markdone => '¿Marcar como hecho?';

  @override
  String get pendingapproval => 'Pendiente de Aprobación';

  @override
  String get filedoesnotexist => 'El archivo no existe.';

  @override
  String get couldnotdeletefile => 'Error: No se pudo eliminar el archivo';

  @override
  String get deletefile => 'Advertencia: procederá a eliminar este archivo permanentemente';

  @override
  String get deletetask => 'Advertencia: procederá a eliminar esta tarea permanentemente';

  @override
  String get calendar => 'Calendario';

  @override
  String get deleteaccount => 'Eliminar Cuenta';

  @override
  String get invalidcredentials => 'Error: Fallo al eliminar la cuenta, credenciales inválidas';

  @override
  String get dailyassignlimit => 'El límite diario de asignación es cinco';

  @override
  String get unabletofetchinternet => 'No se puede obtener contactos.\nPor favor, verifica tu conexión a internet';

  @override
  String get monday => 'Lunes';

  @override
  String get tuesday => 'Martes';

  @override
  String get wednesday => 'Miércoles';

  @override
  String get thursday => 'Jueves';

  @override
  String get friday => 'Viernes';

  @override
  String get saturday => 'Sábado';

  @override
  String get sunday => 'Domingo';

  @override
  String get tassign => '2-Asignar';

  @override
  String get eraseall => '¡Advertencia! Todo lo que has recopilado se borrará.\n\nEsta es una acción irreversible, ¿estás seguro de que quieres continuar?';

  @override
  String get accountdelfailedinternet => 'Error al eliminar la cuenta, por favor verifica tu conexión a internet';

  @override
  String get maximumcloudsize => 'Desafortunadamente, has excedido el tamaño máximo de carga en la nube de 150 KB';

  @override
  String get failedrequestinternet => 'Error al enviar la solicitud.\nPor favor, verifica tu conexión a internet';

  @override
  String get accountdoesnotexist => 'Fallo en la solicitud\nEste usuario puede haber eliminado su cuenta o su cuenta puede haber sido suspendida';

  @override
  String get settimeperiod => 'Por favor, establezca el período correcto. La hora de inicio no puede ser igual o después de la hora de finalización.';

  @override
  String get january => 'Enero';

  @override
  String get february => 'Febrero';

  @override
  String get march => 'Marzo';

  @override
  String get april => 'Abril';

  @override
  String get may => 'Mayo';

  @override
  String get june => 'Junio';

  @override
  String get july => 'Julio';

  @override
  String get august => 'Agosto';

  @override
  String get september => 'Septiembre';

  @override
  String get october => 'Octubre';

  @override
  String get november => 'Noviembre';

  @override
  String get december => 'Diciembre';

  @override
  String get sun => 'DOM';

  @override
  String get mon => 'LUN';

  @override
  String get tue => 'MAR';

  @override
  String get wed => 'MIÉ';

  @override
  String get thu => 'JUE';

  @override
  String get fri => 'VIE';

  @override
  String get sat => 'SÁB';

  @override
  String get personalinfotodo => 'Crea tus tareas aquí, aparecerán como una lista';

  @override
  String get calendarinfoyear => 'Toca el año o desplázate por los años';

  @override
  String get calendarinfomonth => 'Toca el mes o desplázate por los meses';

  @override
  String get calendarinfodays => 'Toca la fecha de tu elección';

  @override
  String get calendarinfoweekss => 'Toca la semana de tu elección';

  @override
  String get personalinfoaccount => 'Escribe/ve una cuenta de tus tareas o crea un diario';

  @override
  String get personalinfoassign => 'Asigna tareas para que las realicen otros en tus contactos';

  @override
  String get homeinfoassigned => 'Las tareas asignadas por tus contactos del hogar aparecerán aquí';

  @override
  String get workinfoassigned => 'Las tareas asignadas por tus contactos laborales aparecerán aquí';

  @override
  String get disableInfo => 'Para desactivar las sugerencias de su aplicación, \ntoca el icono de perfil. En el menú de perfil que aparece. Cambia el menú de sugerencias a \'apagado\'.';

  @override
  String get info => 'Información';

  @override
  String get hints => 'Habilitar sugerencias';

  @override
  String get effectchanges => 'Para efectuar estos cambios, la aplicación se reiniciará. ¿Desea continuar?';
}
