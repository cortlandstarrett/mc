package org.xtuml.aslloader.parser;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.UncheckedIOException;
import java.net.URI;
import java.nio.file.Path;
import java.util.Stack;

import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;
import org.antlr.v4.runtime.misc.ParseCancellationException;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import io.ciera.runtime.instanceloading.generic.IGenericLoader;
import io.ciera.runtime.instanceloading.generic.util.LOAD;
import io.ciera.runtime.summit.exceptions.XtumlException;
import io.ciera.runtime.summit.util.CommandLine;

public class AslImportParser implements IGenericLoader {

  private LOAD loader;
  private Stack<URI> parsingResources;

  public AslImportParser() {
    parsingResources = new Stack<>();
  }

  // parse an ASL file
  public void parseFile(final URI fileURI) throws IOException {
    parsingResources.push(fileURI);
    System.out.println("Parsing resource: " + fileURI);

    try (InputStream is = fileURI.toURL().openConnection().getInputStream()) {
      final String filename = new File(fileURI.getPath()).getName();

      // Tokenize the file
      CharStream input = CharStreams.fromStream(is);
      AslLexer lexer = new AslLexer(input);
      AslParser parser = new AslParser(new CommonTokenStream(lexer));
      parser.removeErrorListeners();
      parser.addErrorListener(
          new BaseErrorListener() {
            @Override
            public void syntaxError(
                Recognizer<?, ?> recognizer,
                Object offendingSymbol,
                int line,
                int charPositionInLine,
                String msg,
                RecognitionException e)
                throws ParseCancellationException {
              throw new ParseCancellationException(
                  filename + ": line " + line + ":" + charPositionInLine + " " + msg);
            }
          });

      // Parse the file
      ParserRuleContext ctx = parser.target();

      // Walk the parse tree
      ParseTreeWalker walker = new ParseTreeWalker();
      AslPopulator listener = new AslPopulator(loader, filename);
      walker.walk(listener, ctx);

    } catch (IOException e) {
      throw new UncheckedIOException(e);
    } finally {
      parsingResources.pop();
    }
  }

  // main load
  public void load(LOAD loader, String args[]) {
    this.loader = loader;
    try {

      // parse command line arguments
      CommandLine cli = new CommandLine(args);
      cli.register_value("i", "input", "Path to a ASL file", "", true);
      cli.read_command_line();
      String inputFile = cli.get_value("i");

      // parse domain model
      parseFile(new File(inputFile).toURI());

    } catch (IOException | XtumlException e) {
      throw new RuntimeException(e);
    }
  }
}
