class ProfileUtils {
  static String getDepartmentDisplayName(String department) {
    switch (department) {
      case 'softwareDevelopment':
        return 'Software Development / Engineering';
      case 'mobileAppDevelopment':
        return 'Mobile App Development';
      case 'uiUxDesign':
        return 'UI/UX & Design';
      case 'qualityAssurance':
        return 'Quality Assurance (QA) / Testing';
      case 'devOps':
        return 'DevOps / IT Infrastructure';
      case 'projectManagement':
        return 'Project Management / Product Management';
      case 'businessDevelopment':
        return 'Business Development / Sales';
      case 'humanResources':
        return 'Human Resources (HR)';
      case 'financeAccounts':
        return 'Finance & Accounts';
      default:
        return department;
    }
  }
  static String getEmployeeTypeDisplayName(String employeeType) {
    switch (employeeType) {
      case 'permanent':
        return 'Permanent';
      case 'temporary':
        return 'Temporary';
      default:
        return employeeType;
    }
  }
  static String getBranchCodeDisplayName(String branchCode) {


    return branchCode.toUpperCase();
  }
}
