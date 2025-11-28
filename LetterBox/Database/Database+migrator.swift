import Foundation
import GRDB

extension Database {
    var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        migrator.registerMigration("v1") { db in
            try createCategoryTable(db)
            try createCardTable(db)
        }
        return migrator
    }

    private func createCategoryTable(_ db: GRDB.Database) throws {
        try db.create(table: "category") { table in
            table.autoIncrementedPrimaryKey("id")
            table.column("name", .text).notNull()
        }
    }

    private func createCardTable(_ db: GRDB.Database) throws {
        try db.create(table: "card") { table in
            table.autoIncrementedPrimaryKey("id")
            table.column("from", .text).notNull()
            table.column("date", .date).notNull()
            table.column("note", .text)
            table.belongsTo("category", onDelete: .cascade)
                .notNull()
        }
    }
}
