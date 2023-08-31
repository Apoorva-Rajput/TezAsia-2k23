// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

contract data {
    struct Patients{
        string ic;
        string name;
        string phone;
        string gender;
        string dob;
        string bloodgroup;
        string allergies;
        string medication;
        address addr;
        uint date;
    }
    struct Doctors{
        string ic;
        string name;
        string phone;
        string gender;
        string dob;
        string qualification;
        address addr;
        uint date;
    }
    address public owner;
    address[] public patientList;
    address[] public doctorList;

    mapping(address => Patients) patients;
    mapping(address => Doctors) doctors;

    mapping(address=>mapping(address=>bool)) isApproved;
    mapping(address => bool) isPatient;
    mapping(address => bool) isDoctor;

    uint256 public patientCount = 0;
    uint256 public doctorCount = 0;

    constructor(){
        owner = msg.sender;
    }

    function setDetails(string memory _ic, string memory _name, string memory _phone, string memory _gender, string memory _dob, string memory _bloodgroup, string memory _allergies, string memory _medication) public {
        require(!isPatient[msg.sender]);
        Patients storage p = patients[msg.sender];
        
        p.ic = _ic;
        p.name = _name;
        p.phone = _phone;
        p.gender = _gender;
        p.dob = _dob;
        p.bloodgroup = _bloodgroup;
        p.allergies = _allergies;
        p.medication = _medication;
        p.addr = msg.sender;

        patientList.push(msg.sender);
        isPatient[msg.sender] = true;
        isApproved[msg.sender][msg.sender] = true;
        patientCount++;
        
    }

    function setDoctor(string memory _ic, string memory _name, string memory _phone, string memory _gender, string memory _dob, string memory _qualification) public {
        require(!isDoctor[msg.sender]);
        Doctors storage d = doctors[msg.sender];
        
        d.ic = _ic;
        d.name = _name;
        d.phone = _phone;
        d.gender = _gender;
        d.dob = _dob;
        d.qualification = _qualification;
        d.addr = msg.sender;
        
        doctorList.push(msg.sender);
        isDoctor[msg.sender] = true;
        doctorCount++;
    }

    function givePermission(address _address) public returns(bool success) {
        isApproved[msg.sender][_address] = true;
        return true;
    }
    function getPatients() public view returns(address[] memory) {
        return patientList;
    }
    function getDoctors() public view returns(address[] memory) {
        return doctorList;
    }

    function searchPatientDemographic(address _address) public view returns(string memory, string memory, string memory, string memory, string memory) {
        require(isApproved[_address][msg.sender]);
        
        Patients storage p = patients[_address];
        
        return (p.ic, p.name, p.phone, p.gender, p.dob);
    }

    function searchPatientMedical(address _address) public view returns(string memory, string memory, string memory) {
        require(isApproved[_address][msg.sender]);
        
        Patients storage p = patients[_address];
        
        return ( p.bloodgroup, p.allergies, p.medication);
    }

    function searchDoctor(address _address) public view returns(string memory, string memory, string memory, string memory, string memory, string memory) {
        require(isDoctor[_address]);
        
        Doctors storage d = doctors[_address];
        
        return (d.ic, d.name, d.phone, d.gender, d.dob, d.qualification);
    }

    function getPatientCount() public view returns(uint256) {
        return patientCount;
    }
    function getDoctorCount() public view returns(uint256) {
        return doctorCount;
    }

}