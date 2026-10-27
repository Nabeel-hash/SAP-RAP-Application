@EndUserText.label : 'TMD demo - simulated CO / premise / DL'
// DEMO ONLY: stands in for EHAUISU / EVBS / EGPL on a system without IS-U.
// On S/4HANA 2025 this table is not needed: the released Utilities RAP BOs create real objects.
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztmd_obj {
  key client      : abap.clnt not null;
  key object_type : abap.char(4) not null;   // CO, PREM, DL
  key object_id   : abap.char(30) not null;
  seq             : abap.int4;
  parent_co       : abap.char(30);
  parent_premise  : abap.char(10);
  house_number    : abap.char(10);
  street          : abap.char(60);
  supplement      : abap.char(10);
  city_name       : abap.char(40);
  postal_code     : abap.char(10);
  region          : abap.char(3);
  country         : abap.char(3);
  plant           : abap.char(4);
  division        : abap.char(1);          // E, G, L for device locations
  description     : abap.char(40);
  request_uuid    : sysuuid_x16;
  created_by      : abp_creation_user;
  created_at      : abp_creation_tstmpl;
}
