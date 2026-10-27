@EndUserText.label: 'Service / scenario'
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.dataCategory: #VALUE_HELP
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZI_TMD_ScenarioVH
  as select from ZI_TMD_Scenario
{
      @ObjectModel.text.element: [ 'Description' ]
      @UI.textArrangement: #TEXT_FIRST
  key ScenarioID,
      @Semantics.text: true
      Description
}
