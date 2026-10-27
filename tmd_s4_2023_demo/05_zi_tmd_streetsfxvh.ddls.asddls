@EndUserText.label: 'Street suffix'
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.dataCategory: #VALUE_HELP
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZI_TMD_StreetSfxVH
  as select from ztmd_values
{
      @ObjectModel.text.element: [ 'Description' ]
      @UI.textArrangement: #TEXT_FIRST
  key cast( value_code as abap.char(10) ) as StreetSuffix,
      @Semantics.text: true
      value_text                          as Description,
      @UI.hidden: true
      sort_order                          as SortOrder
}
where list_id = 'SFX'
