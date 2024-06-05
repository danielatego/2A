class CloudStorageException implements Exception {
  const CloudStorageException();
}

//C in CRUD
class CouldNotCreateCloudUserException extends CloudStorageException {}

class CouldNotCreateCloudWorkException extends CloudStorageException {}

//R in CRUD
class CouldNotGetAllCloudUsersException extends CloudStorageException {}

//U in CRUD
class CouldNotUpdateCloudUserException extends CloudStorageException {}

class CouldNotUpdateCloudWorkException extends CloudStorageException {}

//D in CRUD
class CouldNotDeleteCloudUserException extends CloudStorageException {}

class CouldNotDeleteCloudLocalProfilePicException
    extends CloudStorageException {}
