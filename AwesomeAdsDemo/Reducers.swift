//
//  Reducers.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import SAModelSpace

func appReducer (_ previous: AppState, event: Event) -> AppState {
    return AppState(loginState: loginReducer(previous.loginState, event: event),
                    profileState: profileReducer(previous.profileState, event: event),
                    appState: appsReducer(previous.appState, event: event),
                    companiesState: companiesReducer(previous.companiesState, event: event),
                    selectedPlacement: selectedPlacementReducer(previous.selectedPlacement, event: event),
                    creativesState: creativesReducer(previous.creativesState, event: event),
                    adState: adStateReducer(previous.adState, event: event))
}

func loginReducer (_ previous: LoginState, event: Event) -> LoginState {
    
    var state = previous
    state.loginError = false
    
    switch event {
    case .LoadingJwtToken:
        state.isLoading = true
        return state
    case .NoJwtToken:
        return state
    case .JwtTokenError:
        state.isLoading = false
        state.loginError = true
        state.jwtToken = nil
        return state
    case .EditLoginDetails:
        state.isEditing = true
        return state
    case .GotJwtToken(let token):
        state.jwtToken = token
        return state
    default:
        return previous
    }
}

func profileReducer (_ previous: UserProfile?, event: Event) -> UserProfile? {
    switch event {
    case .GotUserProfile(let profile):
        return profile
    case .UserProfileError:
        return nil
    default:
        return previous
    }
}

func appsReducer (_ previous: LoadedAppsState, event: Event) -> LoadedAppsState {
    var state = previous
    state.search = nil
    
    switch event {
    case .GotAppsForCompany(let apps):
        state.apps = apps
        return state
    case .FilterApps(let search):
        state.search = search
        return state
    default:
        return state
    }
}

func companiesReducer (_ previous: CompaniesState, event: Event) -> CompaniesState {
    var state = previous
    state.search = nil
    state.isLoading = false
    
    switch event {
    case .GotCompanies(let companies):
        state.companies = companies
        return state
    case .FilterCompanies(let search):
        state.search = search
        return state
    case .LoadingCompanies:
        state.isLoading = true
        return state
    case .SelectCompany(let company):
        state.selectedCompany = company
        return state
    default:
        return state
    }
}

func selectedPlacementReducer (_ previous: Int?, event: Event) -> Int? {
    switch event {
    case .SelectPlacement(let placement):
        return placement
    default:
        return previous
    }
}

func creativesReducer (_ previous: CreativesState, event: Event) -> CreativesState {
    var state = previous
    state.search = nil
    
    switch event {
    case .GotCreatives(let creatives):
        state.creatives = creatives
        return state
    case .FilterCreatives(let search):
        state.search = search
        return state
    case .SelectCreative(let creative):
        state.selectedCreative = creative
        return state
    default:
        return state
    }
}

func adStateReducer (_ previous: AdState, event: Event) -> AdState {
    var state = previous
    switch event {
    case .GotResponse(let response, let format):
        state.response = response
        state.format = format
        return state
    default:
        return state
    }
}


