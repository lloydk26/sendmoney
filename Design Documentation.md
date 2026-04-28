# PadalaQ — Design Documentation

## Architecture Overview

PadalaQ follows **Feature-First Clean Architecture** with three strict layers per feature:

```
presentation  →  domain  →  data
```

- **`data`** — API clients (Retrofit), request/response contracts (JSON serializable). Knows nothing about the UI.
- **`domain`** — Business entities (Equatable), mappers (AutoMappr), and service interfaces + implementations. Owns all business logic.
- **`presentation`** — Cubits (BLoC), Freezed states, and Views. Only talks to domain services, never to APIs directly.

Dependency flow is one-directional and enforced: `presentation` can call `domain`, `domain` can call `data`, but never the reverse.

Cross-cutting concerns live in `core/`:
- `core/storage` — `SecureStorageService` (token persistence via flutter_secure_storage)
- `core/cache` — `WalletCacheService` (offline data via SharedPreferences)
- `core/network` — `DioProvider`, `AppModule` (DI wiring)
- `core/theme` — Design system tokens (colors, text styles, button styles)

---


## Sequence Diagrams

### 1. App Launch — Token Check & Auto Login

```mermaid
sequenceDiagram
    actor User
    participant App as MyApp
    participant SS as SecureStorageService
    participant DashboardView
    participant LoginView

    User->>App: Launch app
    App->>SS: getToken()
    SS-->>App: token / null

    alt Token exists
        App->>DashboardView: Navigate (skip login)
    else No token
        App->>LoginView: Navigate to login
    end
```

---

### 2. Login Flow

```mermaid
sequenceDiagram
    actor User
    participant LV as LoginView
    participant LC as LoginCubit
    participant AS as AuthService
    participant API as AuthApi (Retrofit)
    participant SS as SecureStorageService
    participant DV as DashboardView

    User->>LV: Enter username & password, tap Sign In
    LV->>LC: login(user, password)
    LC->>LC: emit(loading)
    LC->>AS: login(user, password)
    AS->>API: POST /user/login
    API-->>AS: LoginResponseContract

    AS->>AS: mapper.convert → AuthEntity
    AS-->>LC: AuthEntity

    LC->>SS: saveToken(accessToken)
    LC->>LC: emit(success(entity))
    LV->>DV: Navigator.pushReplacement

    alt API Error
        API-->>AS: DioException
        AS-->>LC: throw Exception(message)
        LC->>LC: emit(error(message))
        LV->>User: Show error snackbar
    end
```

---

### 3. Dashboard Load — Online & Offline

```mermaid
sequenceDiagram
    actor User
    participant DV as DashboardView
    participant DC as DashboardCubit
    participant DS as DashboardService
    participant API as DashboardApi (Retrofit)
    participant SS as SecureStorageService
    participant WC as WalletCacheService

    User->>DV: Arrive on Dashboard
    DV->>DC: loadWalletData()
    DC->>DC: emit(loading)
    DC->>DS: getWalletData()
    DS->>SS: getToken()
    SS-->>DS: Bearer token
    DS->>API: GET /wallet/transaction-history

    alt Online — success
        API-->>DS: WalletApiResponse
        DS->>DS: mapper.convert → WalletEntity
        DS-->>DC: WalletEntity
        DC->>WC: saveWallet(wallet)
        DC->>DC: emit(success(wallet))
        DV->>User: Show balance + transactions
    else Offline or API failure
        API-->>DS: Exception
        DS-->>DC: throw Exception
        DC->>WC: readWallet()

        alt Cache exists
            WC-->>DC: WalletEntity (cached)
            DC->>DC: emit(success(cached))
            DV->>User: Show cached balance + transactions
        else No cache
            WC-->>DC: null
            DC->>DC: emit(error(message))
            DV->>User: Show error + retry button
        end
    end

    DC->>DC: listenToConnectivity()
    Note over DC: Auto-calls loadWalletData()<br/>when device comes back online
```

---

### 4. Send Money Flow

```mermaid
sequenceDiagram
    actor User
    participant SV as SendMoneyView
    participant SC as SendMoneyCubit
    participant SS as SendMoneyService
    participant API as SendMoneyApi (Retrofit)
    participant SecSS as SecureStorageService

    User->>SV: Enter account number + amount, tap Send Money
    SV->>SC: sendMoney(accountNumber, amount)
    SC->>SC: emit(loading)
    SC->>SS: sendMoney(accountNumber, amount)
    SS->>SecSS: getToken()
    SecSS-->>SS: Bearer token
    SS->>API: POST /send-money

    alt Success
        API-->>SS: SendMoneyResponseContract
        SS->>SS: mapper.convert → SendMoneyEntity
        SS-->>SC: SendMoneyEntity
        SC->>SC: emit(success(entity, amount))
        SV->>User: Show Transfer Successful bottom sheet
        User->>SV: Tap Done → pop back to Dashboard
    else Error
        API-->>SS: DioException
        SS-->>SC: throw Exception(message)
        SC->>SC: emit(error(message))
        SV->>User: Show error snackbar
    end
```

---

### 5. Logout Flow

```mermaid
sequenceDiagram
    actor User
    participant View as DashboardView / SendMoneyView / TransactionsView
    participant DC as DashboardCubit
    participant SS as SecureStorageService
    participant LV as LoginView

    User->>View: Tap logout icon
    View->>DC: logout()
    DC->>SS: deleteToken()
    SS-->>DC: done
    DC->>DC: emit(loggedOut)
    View->>LV: Navigator.pushAndRemoveUntil (clears stack)
```
