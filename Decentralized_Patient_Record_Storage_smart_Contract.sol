// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PatientContract {
    address public admin;

    struct Record {
        uint timestamp;
        string data;
    }

    struct Patient {
        bool isRegistered;
        string name;
        string[] diseases;
        mapping(address => bool) authorizedDoctors;
        mapping(uint => Record) records;
        mapping(address => Medicine[]) patientMedicines;
        uint recordCount;
    }

    struct Medicine {
        uint id;
        string name;
        string expiryDate;
        string dose;
        uint price;
    } 

    mapping(address => Patient) public patients;

     event MedicinePrescribed(address indexed doctorAddress, address indexed patientAddress, string medicineName);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerPatient(string memory patientName) public {
        require(!patients[msg.sender].isRegistered, "You are already registered as a patient");

        Patient storage newPatient = patients[msg.sender];
        newPatient.isRegistered = true;
        newPatient.name = patientName;
        newPatient.recordCount = 0;
        //patients[msg.sender] = Patient(true, patientName, new string[](0), new Record[](0), 0);
    }

  function getPatientData(address _patientAddress) public view returns (string memory name) {
         return patients[_patientAddress].name;
  }

    function authorizeDoctor(address doctorAddress) public {
        patients[msg.sender].authorizedDoctors[doctorAddress] = true;
    }

    
    function prescribeMedicine(address _patientAddress, uint _medId, string memory _medicineName, string memory _expiryDate, string memory _dose, uint _price) public {
        require(patients[_patientAddress].authorizedDoctors[msg.sender], "You are not authorized to access this patient's data");

        Medicine memory newMedicine = Medicine(_medId,_medicineName, _expiryDate, _dose, _price);
        patients[_patientAddress].patientMedicines[_patientAddress].push(newMedicine);


        emit MedicinePrescribed(msg.sender, _patientAddress, _medicineName);
    }

    function getPrescribedMedicine(address _patientAddress) public view returns (Medicine[] memory) {
       return patients[_patientAddress].patientMedicines[_patientAddress];
    }

}
