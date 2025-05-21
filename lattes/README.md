# Oficial
- [ ] Pesquisa, existe biblioteca/método para extração de dados do cnpq?

  - Lattes Extrator - Ferramenta oficial, extremamente burocrática do cnpq.
  - https://github.com/jpmenachalco/scriptLattes/tree/main/scriptLattes

- [x] Pesquisa, existe biblioteca/parser para extração de dados de arquivo XML?

  - Bibliotecas em R para extração de dados de arquivo XML:

    - [xml2 lib](https://xml2.r-lib.org/)
    - [xmlconvert: xml para df](https://cran.r-project.org/web/packages/xmlconvert/xmlconvert.pdf)

<!-- # Extra oficial

- [ ] Pesquisa, é possível pular o captcha?

- [ ] Teste, interceptar as requisições e descobrir o que é enviado ao completar o captcha.

  - Playwright - biblioteca python para automação de navegadores web
  - burp - ferramenta de interceptação de requisições HTTP
  - mitmproxy - ferramenta de interceptação de requisições HTTP -->


# Tarefa 1

Extrair informações da seção: “Participação em bancas de trabalhos de conclusão”.

X-PATH ".//PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO"

A tarefa final consistirá em escrever um script R para:
- extrair todas as informações de modo estruturado
- de várias seções diferentes (a serem especificadas ainda)
- a partir de N arquivos XML salvos em um diretório local

<!-- [Arquivo XML para executar a tarefa](./gitignore/lattes-professor.xml) -->

Investigando a estrutura do arquivo XML manualmente e baseando-se no formulário do Lattes disponível na página de edição do currículo na plataforma do cnpq encontramos o seguinte padrão, para a seção de “Participação em bancas de trabalhos de conclusão”


![Diagrama de classes do nó de Participação em trabalhos de conclusão](./docs/diagrama_participacao_trabalhos_conclusao.png)

Diagrama de classes do nó de Participação em trabalhos de conclusão

[Link para o diagrama feito com ferramenta disponível em **dbdiagram.io**](https://dbdiagram.io/d/681ebe855b2fc4582ffbdb8b)

A estrutura do nó consiste em um nó raiz chamado `PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO` que contém os seguintes nós filhos:

- "PARTICIPACAO-EM-BANCA-DE-MESTRADO"
- "PARTICIPACAO-EM-BANCA-DE-DOUTORADO"
- "PARTICIPACAO-EM-BANCA-DE-EXAME-QUALIFICACAO"
- "PARTICIPACAO-EM-BANCA-DE-APERFEICOAMENTO-ESPECIALIZACAO"
- "PARTICIPACAO-EM-BANCA-DE-GRADUACAO"

Cada um dos nós compartilha a mesma estrutura de  filhos, assim uma classe genérica chamada `PARTICIPACAO-EM-BANCA` foi criada posibilitando a simplificação do modelo de classes.

O atributo `natureza` é comum a todos os nós e está presente na classe `DADOS-BASICOS-DE-PARTICIPACAO-EM-BANCA`, esse atributo informa se a participação foi em banca de mestrado, doutorado, exame de qualificação, aperfeiçoamento ou graduação.

---