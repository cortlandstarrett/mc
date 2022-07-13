package org.xtuml.aslloader.parser;

import org.antlr.v4.runtime.ParserRuleContext;

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
  public void exitAssignStatement(AslParser.AssignStatementContext ctx) {
    call_function(
        ctx,
        "assignStatement_exit",
        filename,
        ctx.start.getLine(),
        ctx.start.getCharPositionInLine(),
        ctx.getText(),
        ctx.lhs != null ? ctx.lhs.getText() : "",
        ctx.EQUAL() != null ? ctx.EQUAL().getText() : "",
        ctx.rhs != null ? ctx.rhs.getText() : "");
  }

  private Object call_function(ParserRuleContext ctx, String function_name, Object... args) {
    try {
      return loader.call_function(function_name, args);
    } catch (XtumlException e) {
      Throwable e1 = e;
      if (e.getCause() != null && e.getCause().getCause() != null) {
        e1 = e.getCause().getCause();
      }
      new RuntimeException("Semantic error at: " + filename + ":" + ctx.getStart().getLine(), e1)
          .printStackTrace();
      System.exit(1);
      return null;
    }
  }
}
