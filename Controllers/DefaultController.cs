using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Rolodex_Contacts.Models;

namespace Rolodex_Contacts.Controllers
{
    public class DefaultController : Controller
    {
        private RolodexEntities db = new RolodexEntities();
        // GET: Default
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult getContactNames()

        {
            var model = (db.Contact_Names.ToList()
                        .Select(x => new
                        {
                            masterId = x.Id,
                            First_Name = x.First_Name,
                            Last_Name = x.Last_Name,
                            addedDate = x.orderDate
                        })).ToList();

            return Json(new
            {

                data = model
            }, JsonRequestBehavior.AllowGet);

        }

        public ActionResult SaveContact(Contact_Names contact)
        {
            var masterId = Guid.NewGuid();
            var contactMaster = new Contact_Names()
            {
                Id = masterId,
                First_Name = contact.First_Name,
                Last_Name = contact.Last_Name,
                orderDate = contact.orderDate,
                key = contact.key
            };
            if(null != db.Contact_Names.Find(contactMaster.key) )
            {
                var check = new Contact_Names();
                check = db.Contact_Names.Where(w => w.Id == contactMaster.key).SingleOrDefault();
                check.First_Name = contact.First_Name;
                check.Last_Name = contact.Last_Name;

                if (contact.Contact_Info.Any())
                {
                    foreach (var item in contact.Contact_Info)
                    {
                        var detailCheck = new Contact_Info()
                        {
                            Phone_Number = item.Phone_Number,
                            Email = item.Email,
                            Note = item.Note
                        };

                        detailCheck = db.Contact_Info.Where(i => i.uni_id == contactMaster.key).SingleOrDefault();
                        detailCheck.Phone_Number = item.Phone_Number;
                        detailCheck.Email = item.Email;
                        detailCheck.Note = item.Note;
                    }
                }
                
            } else
            {
                db.Contact_Names.Add(contactMaster);
                //Process Contact details
                if (contact.Contact_Info.Any())
                {
                    foreach (var item in contact.Contact_Info)
                    {
                        var detailId = Guid.NewGuid();
                        var contactDetails = new Contact_Info()
                        {
                            Id = detailId,
                            uni_id = masterId,
                            Phone_Number = item.Phone_Number,
                            Email = item.Email,
                            Note = item.Note
                        };

                        db.Contact_Info.Add(contactDetails);

                    }
                }
            }
            try
            {
                if (db.SaveChanges() > 0)
                {
                    return Json(new { error = false, message = "Contact saved successfully" });
                }
            }
            catch (Exception ex)
            {
                return Json(new { error = true, message = ex.Message });
            }

            return Json(new { error = true, message = "An unknown error has occured" });

        }

        public ActionResult GetSingleContact(Guid contactId)
        {
            var model = (from ord in db.Contact_Names.AsEnumerable()
                         where ord.Id == contactId
                         select new Contact_Names()
                         {
                             Id = ord.Id,
                             First_Name = ord.First_Name,
                             Last_Name = ord.Last_Name
                         }).SingleOrDefault();

            if (model != null)
            {
                model.Contact_Info = (from od in db.Contact_Info.AsEnumerable()
                                      where od.uni_id == model.Id
                                      select new Contact_Info()
                                      {
                                          Id = od.Id,
                                          Phone_Number = od.Phone_Number,
                                          Email = od.Email,
                                          Note = od.Note
                                      }).ToList();
            }

            return Json(new { result = model }, JsonRequestBehavior.AllowGet);
        }


        public ActionResult deleteContactItem(Guid id)
        {
            var contact = db.Contact_Info.Find(id);
            if (null != contact)
            {
                db.Contact_Info.Remove(contact);
                db.SaveChanges();
                return Json(new { error = false });
            }
            return Json(new { error = true });
        }
        public ActionResult getSingleContactDetail(Guid id)
        {
            var orderDetail = (from od in db.Contact_Info.AsEnumerable()
                               where od.Id == id
                               select new Contact_Info()
                               {
                                   Id = od.Id,
                                   Phone_Number = od.Phone_Number,
                                   Email = od.Email,
                                   Note = od.Note
                               }).SingleOrDefault();

            return Json(new { result = orderDetail }, JsonRequestBehavior.AllowGet);
        }


        public ActionResult deleteContact(Guid id)
        {

            var contactInfo = db.Contact_Info.Where(l => l.uni_id == id).FirstOrDefault();
            

            var contact = db.Contact_Names.Find(id);

            if (null != contact)
            {
                if (null != contactInfo)
                {
                    db.Contact_Info.Remove(contactInfo);
                    db.SaveChanges();
                }
                db.Contact_Names.Remove(contact);
                db.SaveChanges();
                return Json(new { error = false });
            }
            return Json(new { error = true });
        }




    }
}