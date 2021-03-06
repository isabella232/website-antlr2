/* objc_decl.g
 * Author : Sumana Srinivasan, NeXT Inc.
 *
 * SOFTWARE RIGHTS
 *
 * This file is a part of the ANTLR-based C++ grammar and is free
 * software.  We do not reserve any LEGAL rights to its use or
 * distribution, but you may NOT claim ownership or authorship of this
 * grammar or support code.  An individual or company may otherwise do
 * whatever they wish with the grammar distributed herewith including the
 * incorporation of the grammar or the output generated by ANTLR into
 * commerical software.  You may redistribute in source or binary form
 * without payment of royalties to us as long as this header remains
 * in all source distributions.
 *
 * We encourage users to develop parsers/tools using this grammar.
 * In return, we ask that credit is given to us for developing this
 * grammar.  By "credit", we mean that if you incorporate our grammar or
 * the generated code into one of your programs (commercial product,
 * research project, or otherwise) that you acknowledge this fact in the
 * documentation, research report, etc....  In addition, you should say nice
 * things about us at every opportunity.
 *
 * As long as these guidelines are kept, we expect to continue enhancing
 * this grammar.  Feel free to send us enhancements, fixes, bug reports,
 * suggestions, or general words of encouragement at parrt at antlr org
 * 
 * NeXT Computer Inc.
 * 900 Chesapeake Dr.
 * Redwood City, CA 94555
 * 12/02/1994
 */

objc_declarations :
          objc_class_interface
        | objc_class_implementation
        | objc_class_declaration
        | objc_protocol_definition
        | method_definition
        ;

objc_class_name :
          Tok_identifier objc_protocolRef
        ;

objc_class_interface :
     "@interface" Tok_identifier
     ( objc_category_interface objc_protocolRef 
       { interface_declaration_list } "@end" { ";" }
     | { super_class_specification } objc_protocolRef { instance_variables }
	 { interface_declaration_list } "@end" { ";" } )
        ;

objc_category_interface :
          "\(" Tok_identifier objc_protocolRef "\)"
        ;

super_class_specification :
          ":" Tok_identifier
        ;

objc_protocolRef :
          ( "\<" Tok_identifier ( "," Tok_identifier )* "\>" | )
        ;

instance_variables :
          "\{" ( member_declaration | "@public" | "@private" |  
	"@protected" )* "
	\}" { ";" }
        ;

interface_declaration_list :
          ( declaration | method_declaration )+
        ;

method_declaration :
          ( class_method_declaration | instance_method_declaration )
        ;

class_method_declaration :
          "\+" { method_type } method_selector ";"
        ;

instance_method_declaration :
          "\-" { method_type } method_selector ";"
        ;

method_type :
          "\(" type_id "\)"
        ;

method_selector :
          unary_selector
        | keyword_selector { addarg_selector }
        ;

unary_selector :
          selector
        ;

keyword_selector :
          ( keyword_declarator )+
        ;

keyword_declarator :
          { selector } ":" { method_type } ( Tok_identifier | Tok_idKey )
        ;

selector :
          Tok_selector
        ;

addarg_selector :
          "," parameter_declaration_list
        ;

objc_class_implementation :
          "@implementation" Tok_identifier { ";" } (  
objc_category_interface { implementation_definition_list } "@end" { ";" } | {  
super_class_specification } {
 instance_variables } { implementation_definition_list } "@end" { ";" } )
        ;

implementation_definition_list :
          ( declaration | method_definition )+
        ;

method_definition :
          ( class_method_definition | instance_method_definition ) { ";" }
        ;

class_method_definition :
          "\+" { method_type } method_selector { ";" } compound_statement
        ;

instance_method_definition :
          "\-" { method_type } method_selector { ";" } compound_statement
        ;

objc_class_declaration :
          "@class" Tok_identifier ( "," Tok_identifier )* ";"
        ;

objc_protocol_definition :
          "@protocol" Tok_identifier objc_protocolRef {  
interface_declaration_li
st } "@end" { ";" }
        ;

selector_expression :
          "@selector" "\(" selector_name "\)"
        ;

selector_name :
          Tok_selector
        | ( Tok_selector ":" | ":" )+
        ;

encode_expression :
          "@encode" "\(" type_id "\)"
        ;

message_expression :
          "\[" expression keyword_list "\]" { Tok_eos }
        ;

keyword_list :
          selector
        | ( { selector } ":" expression )+
        ;

protocol_expression :
          "@protocol" "\(" ( Tok_identifier | Tok_idKey ) "\)"
        ;
