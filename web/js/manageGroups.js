/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function editGrpName(){
    document.getElementById("grpname").contentEditable = true;
    document.getElementById("grpname").focus();
}
function editDesription(){
    document.getElementById("description").contentEditable = true;
    document.getElementById("description").focus();
}
function saveGrpName(){
    document.getElementById("grpname").contentEditable = false;
    document.getElementById("grpname").focus();
}
function saveDesription(){
    document.getElementById("description").contentEditable = false;
    document.getElementById("description").focus();
}
function makeAdmin(){
    confirm("Are you sure ? ");    
}

