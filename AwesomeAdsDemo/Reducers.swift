//
//  Reducers.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

func appReducer (_ previous: AppState, event: Event) -> AppState {
    return AppState(loginState: loginReducer(previous.loginState, event: event),
                    profileState: profileReducer(previous.profileState, event: event),
                    appState: appsReducer(previous.appState, event: event),
                    companiesState: companiesReducer(previous.companiesState, event: event),
                    selectedCompany: selectedCompanyReducer(previous.selectedCompany, event: event),
                    selectedPlacement: selectedPlacementReducer(previous.selectedPlacement, event: event),
                    creativesState: creativesReducer(previous.creativesState, event: event))
}

func loginReducer (_ previous: LoginState?, event: Event) -> LoginState? {
    switch event {
    case .LoadingJwtToken:
        return LoginState(jwtToken: nil, isLoading: true, isEditing: false)
    case .NoJwtToken, .JwtTokenError:
        return nil
    case .EditLoginDetails:
        return LoginState(jwtToken: nil, isLoading: false, isEditing: true)
    case .GotJwtToken(let token):
        return LoginState(jwtToken: token, isLoading: false, isEditing: false)
    default:
        return previous
    }
}

func profileReducer (_ previous: ProfileState?, event: Event) -> ProfileState? {
    switch event {
    case .GotUserProfile(let profile):
        return ProfileState(profile: profile)
    case .UserProfileError:
        return previous
    default:
        return previous
    }
}

func appsReducer (_ previous: LoadedAppsState, event: Event) -> LoadedAppsState {
    var state = previous
    
    switch event {
    case .GotAppsForCompany(let apps):
        return LoadedAppsState(withFullData: apps)
    case .FilterApps(let search):
        state.search = search
        return state
    default:
        return state
    }
}

func companiesReducer (_ previous: CompaniesState, event: Event) -> CompaniesState {
    var state = previous
    
    switch event {
    case .GotCompanies(let companies):
        return CompaniesState(withFullData: companies)
    case .FilterCompanies(let search):
        state.search = search
        return state
    default:
        return state
    }
}

func selectedCompanyReducer (_ previous: Int?, event: Event) -> Int? {
    
    switch event {
    case .SelectCompany(let company):
        return company
    default:
        return previous
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
    
    switch event {
    case .GotCreatives(let creatives):
        return CreativesState(withFullData: creatives)
    case .FilterCreatives(let search):
        state.search = search
        return state
    default:
        return state
    }
}
