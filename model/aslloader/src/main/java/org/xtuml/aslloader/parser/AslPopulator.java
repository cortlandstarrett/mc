package org.xtuml.aslloader.parser;

import io.ciera.runtime.instanceloading.generic.util.LOAD;
import io.ciera.runtime.summit.exceptions.XtumlException;

class AslPopulator extends AslParserBaseListener {

  private final LOAD loader;
  private final String filename;

  public AslPopulator(LOAD loader, String filename) {
    this.loader = loader;
    this.filename = filename;
  }

  @Override
  public void exitStatement(AslParser.StatementContext ctx) {
    call_function(
        "statement_exit",
        filename,
        ctx.start.getLine(),
        ctx.start.getCharPositionInLine(),
        ctx.getText(),
        ctx.SMT() != null ? ctx.SMT().getText() : "",
        ctx.Identifier() != null ? ctx.Identifier().getText() : "",
        ctx.SEMI() != null ? ctx.SEMI().getText() : "");
  }

  private Object call_function(String function_name, Object... args) {
    try {
      return loader.call_function(function_name, args);
    } catch (XtumlException e) {
      // TODO better handling of error here
      e.printStackTrace();
      System.exit(1);
      return null;
    }
  }
}
