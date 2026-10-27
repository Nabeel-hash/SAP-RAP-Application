@EndUserText.label : 'TMD demo - replication request'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztmd_req {
  key client             : abap.clnt not null;
  key request_uuid       : sysuuid_x16 not null;
  request_id             : abap.numc(10);
  scenario_id            : abap.char(3);
  replicate_mode         : abap.char(1);
  is_street_mode         : abap_boolean;
  is_apartment_mode      : abap_boolean;
  ref_connection_object  : abap.char(30);
  ref_premise            : abap.char(10);
  reuse_connection_obj   : abap_boolean;
  number_of_objects      : abap.int4;
  house_number           : abap.char(10);
  increment_value        : abap.int4;
  increment_by           : abap.char(1);
  street_direction       : abap.char(2);
  street_name            : abap.char(60);
  street_suffix          : abap.char(4);
  unit_type              : abap.char(4);
  letter_number_format   : abap.char(3);
  start_letter           : abap.char(1);
  start_number           : abap.int4;
  street_supplement      : abap.char(40);
  city_name              : abap.char(40);
  postal_code            : abap.char(10);
  region                 : abap.char(3);
  country                : abap.char(3);
  premise_type           : abap.char(8);
  maintenance_plant      : abap.char(4);
  key_date               : abap.dats;
  status                 : abap.char(1);
  status_text            : abap.char(30);
  status_criticality     : abap.int1;
  created_by             : abp_creation_user;
  created_at             : abp_creation_tstmpl;
  last_changed_by        : abp_lastchange_user;
  last_changed_at        : abp_lastchange_tstmpl;
  local_last_changed_at  : abp_locinst_lastchange_tstmpl;
}
