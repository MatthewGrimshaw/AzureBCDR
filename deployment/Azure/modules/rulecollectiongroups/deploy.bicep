param parentName string

module common '1-common/common.bicep' = {
  name: 'rcg-common-deployment'
  params: {
    parentName: parentName
  }
}

module hub '2-hub/hub.bicep' = {
  name: 'rcg-hub-deployment'
  params: {
    parentName: parentName
  }
  dependsOn: [
    common
  ]
}

module onPremises '3-on-premises/on-premises.bicep' = {
  name: 'rcg-on-premises-deployment'
  params: {
    parentName: parentName
  }
  dependsOn: [
    hub
  ]
}

module spoke1 '4-Spoke1-ContainerApp1/spoke1.bicep' = {
  name: 'rcg-spoke1-deployment'
  params: {
    parentName: parentName
  }
  dependsOn: [
    onPremises
  ]
}

module spoke2 '5-Spoke2-ContainerApp2/spoke2.bicep' = {
  name: 'rcg-spoke2-deployment'
  params: {
    parentName: parentName
  }
  dependsOn: [
    spoke1
  ]
}

module spoke3 '6-Spoke3-ContainerApp3/spoke3.bicep' = {
  name: 'rcg-spoke3-deployment'
  params: {
    parentName: parentName
  }
  dependsOn: [
    spoke2
  ]
}

module spoke4 '7-Spoke4-Identity/spoke4.bicep' = {
  name: 'rcg-spoke4-deployment'
  params: {
    parentName: parentName
  }
  dependsOn: [
    spoke3
  ]
}

module spoke5 '8-Spoke5-AzureVirtualDesktop/spoke5.bicep' = {
  name: 'rcg-spoke5-deployment'
  params: {
    parentName: parentName
  }
  dependsOn: [
    spoke4
  ]
}
