abstract final class DatabaseTables {
  static const users = 'users';
  static const settings = 'settings';
  static const accounts = 'accounts';
  static const categories = 'categories';
  static const transfers = 'transfers';
  static const movements = 'movements';
  static const exchangeRates = 'exchange_rates';
  static const calculatorCurrencies = 'calculator_currencies';
  static const simulationHistory = 'simulation_history';
  static const debts = 'debts';
  static const subscriptions = 'subscriptions';
}

abstract final class DatabaseViews {
  static const accountBalances = 'account_balances';
}

abstract final class DatabaseSeeds {
  static const systemCategories = <Map<String, Object?>>[
    {
      'id': 'income-salary',
      'name': 'Salario',
      'icon': 'work',
      'color': 0xFF4EDEA3,
      'movement_type': 'income',
    },
    {
      'id': 'income-other',
      'name': 'Otros ingresos',
      'icon': 'add_circle',
      'color': 0xFF4EDEA3,
      'movement_type': 'income',
    },
    {
      'id': 'expense-food',
      'name': 'Alimentación',
      'icon': 'restaurant',
      'color': 0xFFFFB4AB,
      'movement_type': 'expense',
    },
    {
      'id': 'expense-transport',
      'name': 'Transporte',
      'icon': 'directions_car',
      'color': 0xFFFFB4AB,
      'movement_type': 'expense',
    },
    {
      'id': 'expense-home',
      'name': 'Hogar',
      'icon': 'home',
      'color': 0xFFFFB4AB,
      'movement_type': 'expense',
    },
    {
      'id': 'expense-health',
      'name': 'Salud',
      'icon': 'health_and_safety',
      'color': 0xFFFFB4AB,
      'movement_type': 'expense',
    },
    {
      'id': 'expense-entertainment',
      'name': 'Entretenimiento',
      'icon': 'theaters',
      'color': 0xFFFFB4AB,
      'movement_type': 'expense',
    },
    {
      'id': 'expense-subscriptions',
      'name': 'Suscripciones',
      'icon': 'card_membership',
      'color': 0xFFFFB4AB,
      'movement_type': 'expense',
    },
    {
      'id': 'expense-other',
      'name': 'Otros gastos',
      'icon': 'more_horiz',
      'color': 0xFFFFB4AB,
      'movement_type': 'expense',
    },
    {
      'id': 'expense-debts',
      'name': 'Abono a deudas',
      'icon': 'account_balance_wallet',
      'color': 0xFFFFB4AB,
      'movement_type': 'expense',
    },
  ];
}

abstract final class DatabaseSchema {
  static const version = 6;

  static const requiredObjects = <String>{
    DatabaseTables.users,
    DatabaseTables.settings,
    DatabaseTables.accounts,
    DatabaseTables.categories,
    DatabaseTables.transfers,
    DatabaseTables.movements,
    DatabaseTables.exchangeRates,
    DatabaseTables.calculatorCurrencies,
    DatabaseTables.simulationHistory,
    DatabaseTables.debts,
    DatabaseTables.subscriptions,
    DatabaseViews.accountBalances,
    'idx_movements_occurred_at',
    'idx_movements_account_occurred_at',
    'idx_movements_category_occurred_at',
    'idx_movements_type_occurred_at',
    'idx_movements_transfer_id',
    'idx_transfers_occurred_at',
    'idx_exchange_rates_pair_effective_at',
    'idx_simulation_history_created_at',
    'trg_categories_prevent_system_delete',
    'trg_movements_validate_transfer_insert',
    'trg_movements_validate_transfer_update',
    'trg_movements_validate_relations_insert',
    'trg_movements_validate_relations_update',
    'trg_transfers_validate_accounts_insert',
    'trg_transfers_validate_accounts_update',
    'trg_transfers_prevent_financial_update',
  };

  static const createStatements = <String>[
    '''
    CREATE TABLE ${DatabaseTables.users} (
      id TEXT PRIMARY KEY NOT NULL,
      display_name TEXT NOT NULL CHECK (length(trim(display_name)) > 0),
      username TEXT NOT NULL COLLATE NOCASE UNIQUE
        CHECK (length(trim(username)) > 0),
      password_hash TEXT NOT NULL CHECK (length(password_hash) > 0),
      password_salt TEXT NOT NULL CHECK (length(password_salt) > 0),
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL CHECK (updated_at >= created_at)
    )
    ''',
    '''
    CREATE TABLE ${DatabaseTables.settings} (
      id INTEGER PRIMARY KEY NOT NULL CHECK (id = 1),
      user_id TEXT NOT NULL UNIQUE,
      primary_currency_code TEXT NOT NULL
        CHECK (
          primary_currency_code = upper(primary_currency_code)
          AND length(primary_currency_code) BETWEEN 3 AND 8
        ),
      secondary_currency_code TEXT NOT NULL DEFAULT 'CUP'
        CHECK (
          secondary_currency_code = upper(secondary_currency_code)
          AND length(secondary_currency_code) BETWEEN 3 AND 8
        ),
      locale TEXT NOT NULL DEFAULT 'es',
      biometrics_enabled INTEGER NOT NULL DEFAULT 0
        CHECK (biometrics_enabled IN (0, 1)),
      auto_lock_duration_seconds INTEGER
        CHECK (
          auto_lock_duration_seconds IS NULL
          OR auto_lock_duration_seconds >= 0
        ),
      onboarding_completed INTEGER NOT NULL DEFAULT 0
        CHECK (onboarding_completed IN (0, 1)),
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL CHECK (updated_at >= created_at),
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users}(id)
        ON UPDATE CASCADE ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE ${DatabaseTables.accounts} (
      id TEXT PRIMARY KEY NOT NULL,
      user_id TEXT NOT NULL,
      currency_code TEXT NOT NULL
        CHECK (
          currency_code = upper(currency_code)
          AND length(currency_code) BETWEEN 3 AND 8
        ),
      currency_scale INTEGER NOT NULL DEFAULT 2
        CHECK (currency_scale BETWEEN 0 AND 6),
      name TEXT NOT NULL CHECK (length(trim(name)) > 0),
      is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL CHECK (updated_at >= created_at),
      UNIQUE (user_id, currency_code),
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users}(id)
        ON UPDATE CASCADE ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE ${DatabaseTables.categories} (
      id TEXT PRIMARY KEY NOT NULL,
      name TEXT NOT NULL COLLATE NOCASE CHECK (length(trim(name)) > 0),
      icon TEXT NOT NULL CHECK (length(trim(icon)) > 0),
      color INTEGER NOT NULL CHECK (color BETWEEN 0 AND 4294967295),
      movement_type TEXT NOT NULL
        CHECK (movement_type IN ('income', 'expense', 'both')),
      is_system INTEGER NOT NULL DEFAULT 0 CHECK (is_system IN (0, 1)),
      is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL CHECK (updated_at >= created_at),
      UNIQUE (name, movement_type)
    )
    ''',
    '''
    CREATE TABLE ${DatabaseTables.transfers} (
      id TEXT PRIMARY KEY NOT NULL,
      source_account_id TEXT NOT NULL,
      destination_account_id TEXT NOT NULL,
      source_amount_minor INTEGER NOT NULL CHECK (source_amount_minor > 0),
      destination_amount_minor INTEGER NOT NULL
        CHECK (destination_amount_minor > 0),
      exchange_rate TEXT NOT NULL
        CHECK (
          length(trim(exchange_rate)) > 0
          AND CAST(exchange_rate AS REAL) > 0
        ),
      occurred_at INTEGER NOT NULL,
      note TEXT,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL CHECK (updated_at >= created_at),
      CHECK (source_account_id <> destination_account_id),
      FOREIGN KEY (source_account_id) REFERENCES ${DatabaseTables.accounts}(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
      FOREIGN KEY (destination_account_id)
        REFERENCES ${DatabaseTables.accounts}(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
    )
    ''',
    '''
    CREATE TABLE ${DatabaseTables.movements} (
      id TEXT PRIMARY KEY NOT NULL,
      account_id TEXT NOT NULL,
      category_id TEXT,
      transfer_id TEXT,
      type TEXT NOT NULL
        CHECK (
          type IN (
            'opening',
            'income',
            'expense',
            'transfer_in',
            'transfer_out',
            'adjustment'
          )
        ),
      amount_minor INTEGER NOT NULL CHECK (amount_minor > 0),
      occurred_at INTEGER NOT NULL,
      note TEXT,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL CHECK (updated_at >= created_at),
      CHECK (
        (type IN ('transfer_in', 'transfer_out') AND transfer_id IS NOT NULL)
        OR
        (type NOT IN ('transfer_in', 'transfer_out') AND transfer_id IS NULL)
      ),
      CHECK (
        (type IN ('income', 'expense') AND category_id IS NOT NULL)
        OR
        (type NOT IN ('income', 'expense'))
      ),
      CHECK (
        type NOT IN ('transfer_in', 'transfer_out', 'opening')
        OR category_id IS NULL
      ),
      FOREIGN KEY (account_id) REFERENCES ${DatabaseTables.accounts}(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
      FOREIGN KEY (category_id) REFERENCES ${DatabaseTables.categories}(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
      FOREIGN KEY (transfer_id) REFERENCES ${DatabaseTables.transfers}(id)
        ON UPDATE CASCADE ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE ${DatabaseTables.exchangeRates} (
      id TEXT PRIMARY KEY NOT NULL,
      base_currency_code TEXT NOT NULL
        CHECK (
          base_currency_code = upper(base_currency_code)
          AND length(base_currency_code) BETWEEN 3 AND 8
        ),
      quote_currency_code TEXT NOT NULL
        CHECK (
          quote_currency_code = upper(quote_currency_code)
          AND length(quote_currency_code) BETWEEN 3 AND 8
        ),
      rate TEXT NOT NULL
        CHECK (length(trim(rate)) > 0 AND CAST(rate AS REAL) > 0),
      effective_at INTEGER NOT NULL,
      created_at INTEGER NOT NULL,
      CHECK (base_currency_code <> quote_currency_code),
      UNIQUE (base_currency_code, quote_currency_code, effective_at)
    )
    ''',
    '''
    CREATE TABLE ${DatabaseTables.calculatorCurrencies} (
      id TEXT PRIMARY KEY NOT NULL,
      name TEXT NOT NULL CHECK (length(trim(name)) > 0),
      code TEXT NOT NULL COLLATE NOCASE UNIQUE
        CHECK (code = upper(code) AND length(code) BETWEEN 3 AND 8),
      symbol TEXT NOT NULL CHECK (length(trim(symbol)) > 0),
      currency_scale INTEGER NOT NULL DEFAULT 2
        CHECK (currency_scale BETWEEN 0 AND 6),
      units_per_usd TEXT NOT NULL
        CHECK (
          length(trim(units_per_usd)) > 0
          AND CAST(units_per_usd AS REAL) > 0
        ),
      is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL CHECK (updated_at >= created_at)
    )
    ''',
    '''
    CREATE TABLE ${DatabaseTables.simulationHistory} (
      id TEXT PRIMARY KEY NOT NULL,
      currency_code TEXT NOT NULL
        CHECK (
          currency_code = upper(currency_code)
          AND length(currency_code) BETWEEN 3 AND 8
        ),
      currency_scale INTEGER NOT NULL DEFAULT 2
        CHECK (currency_scale BETWEEN 0 AND 6),
      initial_balance_minor INTEGER NOT NULL,
      monthly_income_minor INTEGER NOT NULL CHECK (monthly_income_minor >= 0),
      monthly_expense_minor INTEGER NOT NULL CHECK (monthly_expense_minor >= 0),
      duration_months INTEGER NOT NULL CHECK (duration_months > 0),
      projected_balance_minor INTEGER NOT NULL,
      created_at INTEGER NOT NULL
    )
    ''',
    '''
    CREATE INDEX idx_movements_occurred_at
    ON ${DatabaseTables.movements}(occurred_at DESC, id DESC)
    ''',
    '''
    CREATE INDEX idx_movements_account_occurred_at
    ON ${DatabaseTables.movements}(account_id, occurred_at DESC, id DESC)
    ''',
    '''
    CREATE INDEX idx_movements_category_occurred_at
    ON ${DatabaseTables.movements}(category_id, occurred_at DESC, id DESC)
    WHERE category_id IS NOT NULL
    ''',
    '''
    CREATE INDEX idx_movements_type_occurred_at
    ON ${DatabaseTables.movements}(type, occurred_at DESC, id DESC)
    ''',
    '''
    CREATE INDEX idx_movements_transfer_id
    ON ${DatabaseTables.movements}(transfer_id)
    WHERE transfer_id IS NOT NULL
    ''',
    '''
    CREATE INDEX idx_transfers_occurred_at
    ON ${DatabaseTables.transfers}(occurred_at DESC, id DESC)
    ''',
    '''
    CREATE INDEX idx_exchange_rates_pair_effective_at
    ON ${DatabaseTables.exchangeRates}(
      base_currency_code,
      quote_currency_code,
      effective_at DESC
    )
    ''',
    '''
    CREATE INDEX idx_simulation_history_created_at
    ON ${DatabaseTables.simulationHistory}(created_at DESC, id DESC)
    ''',
    '''
    CREATE VIEW ${DatabaseViews.accountBalances} AS
    SELECT
      a.id AS account_id,
      a.user_id,
      a.currency_code,
      a.currency_scale,
      COALESCE(
        SUM(
          CASE m.type
            WHEN 'opening' THEN m.amount_minor
            WHEN 'income' THEN m.amount_minor
            WHEN 'transfer_in' THEN m.amount_minor
            WHEN 'expense' THEN -m.amount_minor
            WHEN 'transfer_out' THEN -m.amount_minor
            WHEN 'adjustment' THEN m.amount_minor
          END
        ),
        0
      ) AS balance_minor
    FROM ${DatabaseTables.accounts} a
    LEFT JOIN ${DatabaseTables.movements} m ON m.account_id = a.id
    GROUP BY a.id, a.user_id, a.currency_code, a.currency_scale
    ''',
    '''
    CREATE TRIGGER trg_categories_prevent_system_delete
    BEFORE DELETE ON ${DatabaseTables.categories}
    WHEN OLD.is_system = 1
    BEGIN
      SELECT RAISE(ABORT, 'system categories cannot be deleted');
    END
    ''',
    '''
    CREATE TRIGGER trg_movements_validate_transfer_insert
    BEFORE INSERT ON ${DatabaseTables.movements}
    WHEN NEW.type IN ('transfer_in', 'transfer_out')
    BEGIN
      SELECT CASE
        WHEN NEW.type = 'transfer_out' AND NEW.account_id <> (
          SELECT source_account_id
          FROM ${DatabaseTables.transfers}
          WHERE id = NEW.transfer_id
        )
        THEN RAISE(ABORT, 'transfer_out account mismatch')
        WHEN NEW.type = 'transfer_in' AND NEW.account_id <> (
          SELECT destination_account_id
          FROM ${DatabaseTables.transfers}
          WHERE id = NEW.transfer_id
        )
        THEN RAISE(ABORT, 'transfer_in account mismatch')
      END;
    END
    ''',
    '''
    CREATE TRIGGER trg_movements_validate_transfer_update
    BEFORE UPDATE OF account_id, transfer_id, type
    ON ${DatabaseTables.movements}
    WHEN NEW.type IN ('transfer_in', 'transfer_out')
    BEGIN
      SELECT CASE
        WHEN NEW.type = 'transfer_out' AND NEW.account_id <> (
          SELECT source_account_id
          FROM ${DatabaseTables.transfers}
          WHERE id = NEW.transfer_id
        )
        THEN RAISE(ABORT, 'transfer_out account mismatch')
        WHEN NEW.type = 'transfer_in' AND NEW.account_id <> (
          SELECT destination_account_id
          FROM ${DatabaseTables.transfers}
          WHERE id = NEW.transfer_id
        )
        THEN RAISE(ABORT, 'transfer_in account mismatch')
      END;
    END
    ''',
    '''
    CREATE TRIGGER trg_movements_validate_relations_insert
    BEFORE INSERT ON ${DatabaseTables.movements}
    BEGIN
      SELECT CASE
        WHEN NOT EXISTS (
          SELECT 1
          FROM ${DatabaseTables.accounts}
          WHERE id = NEW.account_id AND is_active = 1
        )
        THEN RAISE(ABORT, 'movement account is inactive')
        WHEN NEW.type IN ('income', 'expense') AND NOT EXISTS (
          SELECT 1
          FROM ${DatabaseTables.categories}
          WHERE id = NEW.category_id
            AND is_active = 1
            AND movement_type IN (NEW.type, 'both')
        )
        THEN RAISE(ABORT, 'movement category is incompatible')
      END;
    END
    ''',
    '''
    CREATE TRIGGER trg_movements_validate_relations_update
    BEFORE UPDATE OF account_id, category_id, type
    ON ${DatabaseTables.movements}
    BEGIN
      SELECT CASE
        WHEN NOT EXISTS (
          SELECT 1
          FROM ${DatabaseTables.accounts}
          WHERE id = NEW.account_id AND is_active = 1
        )
        THEN RAISE(ABORT, 'movement account is inactive')
        WHEN NEW.type IN ('income', 'expense') AND NOT EXISTS (
          SELECT 1
          FROM ${DatabaseTables.categories}
          WHERE id = NEW.category_id
            AND is_active = 1
            AND movement_type IN (NEW.type, 'both')
        )
        THEN RAISE(ABORT, 'movement category is incompatible')
      END;
    END
    ''',
    '''
    CREATE TRIGGER trg_transfers_validate_accounts_insert
    BEFORE INSERT ON ${DatabaseTables.transfers}
    BEGIN
      SELECT CASE
        WHEN NOT EXISTS (
          SELECT 1
          FROM ${DatabaseTables.accounts}
          WHERE id = NEW.source_account_id AND is_active = 1
        )
        THEN RAISE(ABORT, 'transfer source account is inactive')
        WHEN NOT EXISTS (
          SELECT 1
          FROM ${DatabaseTables.accounts}
          WHERE id = NEW.destination_account_id AND is_active = 1
        )
        THEN RAISE(ABORT, 'transfer destination account is inactive')
      END;
    END
    ''',
    '''
    CREATE TRIGGER trg_transfers_validate_accounts_update
    BEFORE UPDATE OF source_account_id, destination_account_id
    ON ${DatabaseTables.transfers}
    BEGIN
      SELECT CASE
        WHEN NOT EXISTS (
          SELECT 1
          FROM ${DatabaseTables.accounts}
          WHERE id = NEW.source_account_id AND is_active = 1
        )
        THEN RAISE(ABORT, 'transfer source account is inactive')
        WHEN NOT EXISTS (
          SELECT 1
          FROM ${DatabaseTables.accounts}
          WHERE id = NEW.destination_account_id AND is_active = 1
        )
        THEN RAISE(ABORT, 'transfer destination account is inactive')
      END;
    END
    ''',
    '''
    CREATE TRIGGER trg_transfers_prevent_financial_update
    BEFORE UPDATE OF
      source_account_id,
      destination_account_id,
      source_amount_minor,
      destination_amount_minor,
      exchange_rate
    ON ${DatabaseTables.transfers}
    WHEN EXISTS (
      SELECT 1
      FROM ${DatabaseTables.movements}
      WHERE transfer_id = OLD.id
    )
    BEGIN
      SELECT RAISE(
        ABORT,
        'transfer financial fields are immutable; replace atomically'
      );
    END
    ''',
    '''
    CREATE TABLE ${DatabaseTables.debts} (
      id TEXT PRIMARY KEY NOT NULL,
      user_id TEXT NOT NULL REFERENCES ${DatabaseTables.users}(id) ON DELETE CASCADE,
      name TEXT NOT NULL CHECK (length(trim(name)) > 0),
      amount_minor INTEGER NOT NULL,
      remaining_amount_minor INTEGER NOT NULL DEFAULT 0,
      total_installments INTEGER,
      paid_installments INTEGER NOT NULL DEFAULT 0,
      currency_code TEXT NOT NULL CHECK (length(currency_code) = 3),
      due_date TEXT,
      is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
    ''',
    '''
    CREATE TABLE ${DatabaseTables.subscriptions} (
      id TEXT PRIMARY KEY NOT NULL,
      user_id TEXT NOT NULL REFERENCES ${DatabaseTables.users}(id) ON DELETE CASCADE,
      name TEXT NOT NULL CHECK (length(trim(name)) > 0),
      amount_minor INTEGER NOT NULL,
      currency_code TEXT NOT NULL CHECK (length(currency_code) = 3),
      billing_cycle TEXT NOT NULL CHECK (billing_cycle IN ('monthly', 'yearly', 'weekly')),
      next_billing_date TEXT NOT NULL,
      is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      last_payment_date TEXT
    )
    ''',
  ];
}
