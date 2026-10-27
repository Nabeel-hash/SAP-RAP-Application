@EndUserText.label: 'Connection object (demo)'
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
// DEMO: searches the simulated objects. On 2025: I_UtilsTechObjLocationAddr.
define view entity ZI_TMD_ConnObjVH
  as select from ztmd_obj
{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Connection Object'
  key object_id    as ConnectionObject,
      @EndUserText.label: 'House No.'
      house_number as HouseNumber,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Street'
      street       as Street,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'City'
      city_name    as CityName,
      @EndUserText.label: 'Postal Code'
      postal_code  as PostalCode
}
where object_type = 'CO'
