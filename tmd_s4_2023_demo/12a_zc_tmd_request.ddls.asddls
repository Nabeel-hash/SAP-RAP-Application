@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Custom Premise Replicator Tool'
@ObjectModel.semanticKey: [ 'RequestID' ]
define root view entity ZC_TMD_Request
  provider contract transactional_query
  as projection on ZR_TMD_Request
{
  key RequestUUID,
      @EndUserText.label: 'Request'
      RequestID,
      @EndUserText.label: 'Service / Scenario'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TMD_ScenarioVH', element: 'ScenarioID' } }]
      ScenarioID,
      @EndUserText.label: 'Replicate'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TMD_ReplModeVH', element: 'ReplicateMode' } }]
      ReplicateMode,
      IsStreetMode,
      IsApartmentMode,
      @EndUserText.label: 'Connection Object'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TMD_ConnObjVH', element: 'ConnectionObject' } }]
      RefConnectionObject,
      @EndUserText.label: 'Premise'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TMD_PremiseVH', element: 'Premise' } }]
      RefPremise,
      @EndUserText.label: 'Reuse Connection Object'
      ReuseConnectionObject,
      @EndUserText.label: 'Number to create'
      NumberOfObjects,
      @EndUserText.label: 'House Number'
      HouseNumber,
      @EndUserText.label: 'Increment Value'
      IncrementValue,
      @EndUserText.label: 'Increment By'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TMD_IncrByVH', element: 'IncrementBy' } }]
      IncrementBy,
      @EndUserText.label: 'Street Direction'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TMD_StreetDirVH', element: 'StreetDirection' } }]
      StreetDirection,
      @EndUserText.label: 'Street Name'
      StreetName,
      @EndUserText.label: 'Street Suffix'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TMD_StreetSfxVH', element: 'StreetSuffix' } }]
      StreetSuffix,
      @EndUserText.label: 'Unit Type - Supplement'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TMD_UnitTypeVH', element: 'UnitType' } }]
      UnitType,
      @EndUserText.label: 'Letter Number Format'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TMD_LnFormatVH', element: 'LetterNumberFormat' } }]
      LetterNumberFormat,
      @EndUserText.label: 'Start Letter'
      StartLetter,
      @EndUserText.label: 'Start Number'
      StartNumber,
      @EndUserText.label: 'Street Supplement 1'
      StreetSupplement,
      @EndUserText.label: 'City'
      CityName,
      @EndUserText.label: 'Postal Code'
      PostalCode,
      @EndUserText.label: 'Region'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_RegionVH', element: 'Region' },
                                           additionalBinding: [{ localElement: 'Country', element: 'Country' }] }]
      Region,
      @EndUserText.label: 'Country'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CountryVH', element: 'Country' } }]
      Country,
      @EndUserText.label: 'Premise Type'
      PremiseType,
      @EndUserText.label: 'Maintenance Plant'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Plant', element: 'Plant' } }]
      MaintenancePlant,
      @EndUserText.label: 'Key Date'
      KeyDate,
      @EndUserText.label: 'Status Code'
      Status,
      @EndUserText.label: 'Status'
      StatusText,
      StatusCriticality,
      @EndUserText.label: 'Created By'
      CreatedBy,
      @EndUserText.label: 'Created At'
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _Target : redirected to composition child ZC_TMD_Target
}
