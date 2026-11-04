import java.sql.*;


static void listar(String sql) {


    try (Connection conexao = DriverManager.getConnection("jdbc:sqlite:financas.db");
         Statement stmt = conexao.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {

        // 1- SELECIONAR A TABELA E COLUNA QUE PRECISO NO SELECT
        // 2- MOSTRAR AO GETSTRING DA ONDE ELE VAI PUXAR AS DESCRIÇOES DAS DESPESAS
        // 3- MOSTRAR AO GETDOUBLE DA ONDE PUXAR OS VALORES DAS DESPESAS
        // 4- CONCATENAR A DESCRICAO COM O VALOR


        while (rs.next()) {
            String descricao = rs.getString("descricao");
            double valor = rs.getDouble("valor");
            System.out.println(descricao + " - " + valor);
        }


    } catch (SQLException e) {
        System.out.println("Erro de Conexao " + e.getMessage());

    }
}


static double somar(String sql) {

    try (Connection conexao = DriverManager.getConnection("jdbc:sqlite:financas.db");
         Statement stmt = conexao.createStatement();
         ResultSet rs = stmt.executeQuery(sql)){

        if (rs.next()) {
            return rs.getDouble(1);
        }
    } catch (SQLException e) {
        System.out.println("Erro no banco: " + e.getMessage());
    }
    return 0;
}

static void inserirDespesa(String descricao, double valor, String data,boolean paga, int tipo) {
    String sql = "INSERT INTO Despesas ( descricao, valor, data_Vencimento, paga, tipo) VALUES (?, ?, ?, ?, ?)";

    try (Connection conexao = DriverManager.getConnection("jdbc:sqlite:financas.db");
        PreparedStatement ps = conexao.prepareStatement(sql)){


        ps.setString(1, descricao);   // descricao
        ps.setDouble(2, valor);     // valor
        ps.setString(3, data);   // data no formato AAAA-MM-DD
        ps.setBoolean(4, paga);    // paga
        ps.setInt(5, tipo);        // id do tipo

        ps.executeUpdate();
        System.out.println("Despesa cadastrada");
    } catch (SQLException e) {
        System.out.println("Erro no banco: " + e.getMessage());
    }
}




void main(){
    listar("SELECT descricao, valor FROM Despesas WHERE paga = 0 ");
    listar("SELECT descricao, valor FROM Despesas");
    listar("SELECT descricao, valor FROM Entrada");
    System.out.println(somar("SELECT SUM(valor) FROM Entrada"));

    double saldo = 1000 + somar("SELECT SUM(valor) FROM Entrada") - somar("SELECT SUM(valor) FROM Despesas WHERE paga = 1 ");
    System.out.println(saldo);

    inserirDespesa("Mouse", 250.00, "2026-11-05", false, 4);
    inserirDespesa("Teclado", 250.00, "2026-11-05", true, 4);
    listar("SELECT descricao, valor FROM Despesas");
}