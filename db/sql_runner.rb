require('pg')

class SqlRunner

  # DEFAULT PARAMETER COULD ALSO BE USED
  # def self.run(sql, values = []) FOR EXAMPLE


  def self.run(sql, values = [])

    begin
      db = PG.connect({dbname: 'pizza_orders', host:'localhost'})
      db.prepare('query', sql)
      result = db.exec_prepared('query', values)
    ensure
      db.close() if db != nil
    end
    return result
  end

end
