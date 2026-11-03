import java.sql.*;


static void listar(String sql) {


    try {
        Connection conexao = DriverManager.getConnection("jdbc:sqlite:financas.db");
        System.out.println("Conectado");

        // 1- SELECIONAR A TABELA E COLUNA QUE PRECISO NO SELECT
        // 2- MOSTRAR AO GETSTRING DA ONDE ELE VAI PUXAR AS DESCRIÇOES DAS DESPESAS
        // 3- MOSTRAR AO GETDOUBLE DA ONDE PUXAR OS VALORES DAS DESPESAS
        // 4- CONCATENAR A DESCRICAO COM O VALOR

        Statement stmt = conexao.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

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

    try {
        Connection conexao = DriverManager.getConnection("jdbc:sqlite:financas.db");
        System.out.println("Conectado");
        Statement stmt = conexao.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        if (rs.next()) {
            return rs.getDouble(1);
        }
    } catch (SQLException e) {
        System.out.println("Erro no banco: " + e.getMessage());
    }
    return 0;
}






void main(){
    listar("SELECT descricao, valor FROM Despesas WHERE paga = 0 ");
    listar("SELECT descricao, valor FROM Despesas");
    listar("SELECT descricao, valor FROM Entrada");
    System.out.println(somar("SELECT SUM(valor) FROM Entrada"));

    double saldo = 1000 + somar("SELECT SUM(valor) FROM Entrada") - somar("SELECT SUM(valor) FROM Despesas WHERE paga = 1 ");
    System.out.println(saldo);
}