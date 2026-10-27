@EndUserText.label: 'Premise (demo)'
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
// DEMO: searches the simulated objects. On 2025: I_UtilitiesPremise.
define view entity ZI_TMD_PremiseVH
  as select from ztmd_obj
{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Premise'
  key cast( object_id as abap.char(10) ) as Premise,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Connection Object'
      parent_co                         as ConnectionObject,
      @EndUserText.label: 'Supplement'
      supplement                        as Supplement
}
where object_type = 'PREM'
