// Draft table for ZR_TMD_Request.
// EASIEST: let ADT generate it - in the BDEF (step 08) put the cursor on "ztmd_req_d",
// press Ctrl+1 and choose "Create draft table". Use this source only if the quick fix
// is not offered. Field names = CDS element names (not the DB field names).
@EndUserText.label : 'Draft table for ZR_TMD_Request'
@AbapCatalog.enhancement.category : #EXTENSIBLE_ANY
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztmd_req_d {
  key mandt             : mandt not null;
  key requestuuid       : sysuuid_x16 not null;
  requestid             : abap.numc(10);
  scenarioid            : abap.char(3);
  replicatemode         : abap.char(1);
  isstreetmode          : abap_boolean;
  isapartmentmode       : abap_boolean;
  refconnectionobject   : abap.char(30);
  refpremise            : abap.char(10);
  reuseconnectionobject : abap_boolean;
  numberofobjects       : abap.int4;
  housenumber           : abap.char(10);
  incrementvalue        : abap.int4;
  incrementby           : abap.char(1);
  streetdirection       : abap.char(2);
  streetname            : abap.char(60);
  streetsuffix          : abap.char(4);
  unittype              : abap.char(4);
  letternumberformat    : abap.char(3);
  startletter           : abap.char(1);
  startnumber           : abap.int4;
  streetsupplement      : abap.char(40);
  cityname              : abap.char(40);
  postalcode            : abap.char(10);
  region                : abap.char(3);
  country               : abap.char(3);
  premisetype           : abap.char(8);
  maintenanceplant      : abap.char(4);
  keydate               : abap.dats;
  status                : abap.char(1);
  statustext            : abap.char(30);
  statuscriticality     : abap.int1;
  createdby             : abp_creation_user;
  createdat             : abp_creation_tstmpl;
  lastchangedby         : abp_lastchange_user;
  lastchangedat         : abp_lastchange_tstmpl;
  locallastchangedat    : abp_locinst_lastchange_tstmpl;
  "%admin"              : include sych_bdl_draft_admin_inc;
}
