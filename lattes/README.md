# Oficial
- [ ] Pesquisa, existe biblioteca/método para extração de dados do cnpq?

  - Lattes Extrator - Ferramenta oficial, extremamente burocrática do cnpq.
  - https://github.com/jpmenachalco/scriptLattes/tree/main/scriptLattes

- [ ] Pesquisa, existe biblioteca/parser para extração de dados de arquivo XML?

  - Bibliotecas em R para extração de dados de arquivo XML:
    - xml2
    - xml2r
    - xml2r2
    - ...

# Extra oficial

- [ ] Pesquisa, é possível pular o captcha?

- [ ] Teste, interceptar as requisições e descobrir o que é enviado ao completar o captcha.

  - Playwright - biblioteca python para automação de navegadores web
  - burp - ferramenta de interceptação de requisições HTTP
  - mitmproxy - ferramenta de interceptação de requisições HTTP


# Tarefa 1

Vamos começar extraindo informações da seção: “Participação em bancas de trabalhos de conclusão” (PARTICIPACAO-EM-BANCA-TRABALHOS-CONCLUSAO).

A tarefa final consistirá em escrever um script R para:
- extrair todas as informações de modo estruturado
- de várias seções diferentes (a serem especificadas ainda)
- a partir de N arquivos XML salvos em um diretório local

[Arquivo XML para executar a tarefa](./gitignore/lattes-professor.xml)


[xml2 lib](https://xml2.r-lib.org/)
[xmlconvert](https://cran.r-project.org/web/packages/xmlconvert/xmlconvert.pdf)