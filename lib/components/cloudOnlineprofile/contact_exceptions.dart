class ContactException implements Exception {
  const ContactException();
}

class CouldNotAddHomeContacttoLocaldatabase extends ContactException {}

class CouldNotGetAllCloudUsersException extends ContactException {}

class CouldNotUpdateCloudUserException extends ContactException {}

class CouldNotDeleteCloudUserException extends ContactException {}
