<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Rolodex_Contacts._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card shadow bg-white rounded" style="margin-top: -2em;">
        <div class="card-body">
            <div class="table-responsive">
            <table class="table table-striped table-bordered" id="contacts" style="width:100%">
                <thead>
                    <tr>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>Date Added</th>
                        <th></th>
                        <th class="d-none"></th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
                </div>
        </div>
    </div>
    <button class="btn btn-lg shadow btn-primary" id="addNewContact" style="margin-right: 5px;"><i class="fas fa-plus"></i> Add New</button>

    <div id="newContactModal" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Add New Contact</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
            <div class="modal-body">
                <h3>
                    Contact Name
                </h3>
                <hr />
                <div class="form-horizontal">
                    <input type="hidden" id="orderMasterId" />
                    <div class="form-group form-row">
                        <label class="control-label col-md-2">
                            First Name
                        </label>
                        <div class="col-md-4">
                            <input type="text" id="add_First_Name" placeholder="First Name" class="form-control" maxlength="25"/>
                            <div class="invalid-feedback">
                              First Name Cannot Be Empty.
                            </div>
                        </div>
                        <label class="control-label col-md-2">
                            Last Name
                        </label>
                        <div class="col-md-4">
                            <input type="text" id="add_Last_Name" placeholder="Last Name" class="form-control" maxlength="25"/>
                            <div class="invalid-feedback">
                              Last Name Cannot Be Empty.
                            </div>
                        </div>
                    </div>
                </div>

                <h3 style="margin-top:10px">Contact Information</h3>
                <div class="table-responsive">
                <table id="contactDetailsTable" class="table">
                    <thead>
                        <tr>
                            <th style="width:25%">Phone</th>
                            <th style="width:25%">Email</th>
                            <th style="width:30%">Note</th>
                            <th style="width:20%"></th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                    <tfoot>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td>
                                <a class="btn btn-primary btn" id="addInfo">Add Info</a>
                            </td>
                        </tr>
                    </tfoot>
                </table>
                    </div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button id="saveContact" type="button" class="btn btn-primary">Save Contact</button>
            </div>
        </div>
    </div>
</div>

<div id="contactDetailsModal" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-sm" role="document">
        <div class="modal-content">
            <div class="modal-header">       
                <h4 class="modal-title">Contact Details</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
            <div class="modal-body">

                <div class="form-horizontal">
                    <div class="form-group">
                        <input type="hidden" id="detailId" />
                        <label class="control-label col-md-12">
                            Phone Number
                        </label>
                        <div class="col-md-12">
                            <input type="tel" id="contactPhoneNumber" placeholder="555-555-5555" maxlength="10" class="form-control" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-md-12">
                            Email
                        </label>
                        <div class="col-md-12">
                            <input type="email" id="contactEmail" placeholder="youremail@domain.com" maxlength="25" class="form-control" />
                            <div class="invalid-feedback">
                              Please Enter a Valid Email.
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-md-12">
                            Note
                        </label>
                        <div class="col-md-12">
                            <textarea class="form-control" id="contactNote" maxlength="100" placeholder="Note">

                            </textarea>

                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-md-12">
                            <a id="addToList" class="btn btn-block btn-primary">Save</a>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </div>
</div>

    <script src="https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js"></script>
<script>
    // Ajax to load data on inital load
    $(function () {


        var contactUrl = '../getContactNames';

        var table = $("#contacts").DataTable({
            "processing": true,
            "serverSide": false,
            "filter": true,
            "sort": true,
            "orderMulti": false,
            "ajax": {
                "url": contactUrl,
                "type": "POST",
                "datatype": "json"
            },
            "columns": [

                { "data": "First_Name", "name": "First_Name", "autoWidth": true, "searchable" : true },
                { "data": "Last_Name", "name": "Last_Name", "autoWidth": true, "searchable" : true },
                { "data": "addedDate", "name": "addedDate", "autoWidth": true, "searchable": true },
                { "data":null, "name": "Action", "defaultContent": '<a class="editItem" href="#">Edit <i class="fas fa-edit"></i></a> / <a class="deleteContact" href="#">Delete <i class="fas fa-trash-alt"></i></a>', "autoWidth": false },
                { "data": "masterId", "name": "masterId", "autoWidth": true, "searchable": true }
            ]
            
        }); 

    // Show Add Contact Modal | Fires when add new button is clicked
        $("#addNewContact").click(function (e) {
                e.preventDefault();
                $("#add_First_Name").val('');
                $("#add_Last_Name").val('');
            $('#newContactModal').modal('show');
            $("#addInfo").removeClass("disabled");
            $("#contactDetailsTable tbody").empty();
            $("orderMasterId").val("");
        });

    // Open Contact Details Modal
        $("#addInfo").click(function (e) {
              e.preventDefault();
            $('#contactDetailsModal').modal('show');

         });

    // Add contact information into list
         $("#addToList").click(function (e) {
             e.preventDefault();
             if ($.trim($("#contactPhoneNumber").val()) == "" || $.trim($("#contactEmail").val()) == "" || $.trim($("#contactNote").val()) == "") return;
             if (emailIsValid($.trim($("#contactEmail").val()))) {
                 var contactPhoneNumber = $("#contactPhoneNumber").val(),
                    contactEmail = $("#contactEmail").val(),
                    contactNote = $("#contactNote").val(),
                    detailsTableBody = $("#contactDetailsTable tbody");
                    detailsTableBody.empty();
                var contactEntry = '<tr><td>' + contactPhoneNumber + '</td><td>' + contactEmail + '</td><td>' + contactNote + '</td><td><a data-itemId="0" href="#" class="deleteItem">Remove</a></td></tr>';
                detailsTableBody.append(contactEntry);
             clearItem();
             $("#addInfo").addClass("disabled");
             } else {
                 $("#contactEmail").addClass("is-invalid");
             }
                
        });

    // Clear inputs
        function clearItem() {
                $("#contactPhoneNumber").val('');
                $("#contactEmail").val('');
                $("#contactNote").val('');
                $("#contactDetailsModal .close").click();
        }

    // Save contact data via ajax
        function saveContact(data) {
            return $.ajax({
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                type: 'POST',
                url: '../saveContact',
                data: data
            });
        }

    // Retrieve a single contact via ajax by passing the Id
        function getContact(id) {
                return $.ajax({
                    type: 'GET',
                    url: '../getSingleContact',
                    data: "contactId=" + id
                });
        }

        function getSingleContactDetail(id) {
            return $.ajax({
                type: 'GET',
                url: '../getSingleContactDetail', 
                data: "id=" + id
            });
        }

        function deleteContactItem(id) {
            return $.ajax({
                type: 'POST',
                url: '../deleteContactItem',
                data: "id=" + id
            });
        }


         function deleteContact(id) {
            return $.ajax({
                type: 'POST',
                url: '../deleteContact',
                data: "id=" + id
             });
        }

        $(document).on('click', 'a.deleteItem', function (e) {
            e.preventDefault();
            var $self = $(this);
            if ($(this).attr('data-itemId') == "0") {
                    $(this).parents('tr').css("background-color", "#FF3700").fadeOut(800, function () {
                    $(this).remove();
                });
            } else {
                    $.when(deleteContactItem($(this).attr('data-itemId'))).then(function (res) {
                        $self.parents('tr').css("background-color", "#FF3700").fadeOut(800, function () {
                            $(this).remove();
                        });
                    }).fail(function (err) {
                    });
            }
            $("#addInfo").removeClass("disabled");
        });

        // delete contact
        $(document).on('click', 'a.deleteContact', function (e) {
            var holder = $(this).parent();
            id = holder.next().html();
            console.log(id);
            var $self = $(this);

                    $.when(deleteContact(id)).then(function (res) {
                        holder.parent('tr').css("background-color", "#FF3700").fadeOut(800, function () {
                            $(this).remove();
                        });
                    }).fail(function (err) {
                });
            location.reload();
        });

        // store contact info in an array, prepare for json, and give data to ajax POST
        $("#saveContact").click(function (e) {
            var good;
                e.preventDefault();
                var contactArr = [];

            if ($("#add_First_Name").val().trim().length < 1) {
                $("#add_First_Name").addClass("is-invalid"); good = 0;
            } else {good = 1 }
            if ($("#add_Last_Name").val().trim().length < 1) {
                $("#add_Last_Name").addClass("is-invalid"); good = 0;
            } else { good = 1}
            if ($("#add_First_Name").val().trim().length < 1) {
                $("#add_First_Name").addClass("is-invalid"); good = 0;
            } else {good =1}
            if ($("#contactDetailsTable tbody tr").length < 1) {
                good = 0;
            } else {good =1}
             if (good == 1) {
                 contactArr.length = 0;
                $.each($("#contactDetailsTable tbody tr"), function () {
                    contactArr.push({
                        Phone_Number: $(this).find('td:eq(0)').html().trim(),
                        Email: $(this).find('td:eq(1)').html().trim(),
                        Note: $(this).find('td:eq(2)').html().trim()
                    });
                });
                var d = new Date();
             var stamp = d.toLocaleDateString();
                 var data = JSON.stringify({
                    First_Name: $("#add_First_Name").val().trim(),
                    Last_Name: $("#add_Last_Name").val().trim(),
                    orderDate: stamp,
                    key: $("#orderMasterId").val(),
                    Contact_Info: contactArr
             }); 
                 $.when(saveContact(data)).then(function (response) {
                     console.log(response);
                     $("#newContactModal .close").click();
                     $("#contactDetailsTable tbody").empty();
                }).fail(function (err) {
                    console.log(err);
                     });
                 location.reload();
             } else {
                 
             }
          
        });

            $(document).on("click", '.editItem', function (e) {
                var data = table.row($(this).parents('tr')).data();
                e.preventDefault();
                var id = data.masterId;
                $("#contactDetailsTable tbody").empty();
                $.when(getContact(id)).then(function (res) {
                    var detArr = [];
                    $("#add_First_Name").val(res.result.First_Name);
                    $("#add_Last_Name").val(res.result.Last_Name);
                    $("#orderMasterId").val(res.result.Id);
                    $.each(res.result.Contact_Info, function (i, v) {
                        detArr.push('<tr><td>' + v.Phone_Number + '</td><td>' + v.Email + '</td><td>' + v.Note + '</td><td><a data-itemId="' + v.Id + '" href="#" class="deleteItem">Delete</a> | <a href="#" data-itemId="' + v.Id + '" class="editDetail">Edit</a></td></tr>')
                    });
                    $("#contactDetailsTable tbody").append(detArr);
                    $("#saveContact").html("Save Update");
                    $('#newContactModal').modal('show');
                }).fail(function (err) {
                    console.log(err);
                    });
                if (!$("#contactDetailsTable tbody tr").length) {
                    $("#addInfo").addClass("disabled");
                }
                else {
                    $("#addInfo").removeClass("disabled");
                }
            });

        $(document).on("click", '.editDetail', function (e) {
                e.preventDefault();
                var id = $(this).attr("data-itemid");
                $.when(getSingleContactDetail(id)).then(function (res) {
                    var detArr = [],
                        data = res.result;
                    $("#detailId").val(data.Id);
                    $("#contactPhoneNumber").val(data.Phone_Number);
                    $("#contactEmail").val(data.Email);
                    $("#contactNote").val(data.Note);
                   
                    $('#contactDetailsModal').modal('show');
                }).fail(function (err) {
                    console.log(err);
                });
        });

        //validate 

            $("#contactPhoneNumber").keydown(function(e) {
                var a=[8,9,13,16,17,18,20,27,35,36,37,38,39,40,45,46,91,92];
                var k = e.which;
    
                for (i = 48; i < 58; i++)
                    a.push(i);
                for (i = 96; i < 106; i++)
                    a.push(i);
    
                if (!(a.indexOf(k) >= 0)) {
                    e.preventDefault();
                }
                 $("#contactPhoneNumber").val($("#contactPhoneNumber").val().replace(/\s/g, ''));
            });

        $("#add_First_Name").blur(function () { 
            if ($("#add_First_Name").val().trim().length > 0) {
                    $("#add_First_Name").removeClass("is-invalid");
            } else { }
        });
        $("#add_Last_Name").blur(function () {
            if ($("#add_Last_Name").val().trim().length > 0) {
                $("#add_Last_Name").removeClass("is-invalid");
            } else { }
        });
        $("#contactEmail").blur(function () {
            if (emailIsValid($.trim($("#contactEmail").val()))) {
                $("#contactEmail").removeClass("is-invalid");
            } else {$("#contactEmail").addClass("is-invalid"); }
        });
        function emailIsValid (email) {
          return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
        }
    });
</script>
</asp:Content>



