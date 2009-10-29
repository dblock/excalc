(*              TreeView-32 Calculator Interface Unit (Object Pascal)
                           (c) Daniel Doubrovkine
  Stolen Technologies Inc. - University of Geneva - 1996 - All Rights Reserved
            for Scientific Calculator, version revised on 01.07.96
*)
unit TreeView;

interface

type
    TCalcMode=(Deg,Rad,Hex,Bin,Oct,CurrentMode);
    {type definitions for TNode object}
    ContentsType=(NodeVariable,NodeOperator,NodeSingle,NodeValue);
    ContentsPtr=^Contents;
    Contents=record
     MyValue: extended;
     MyVariable:string;
     MyOperator:string;
     MySingle:string;
              end;{contents record}
    {PNode is the pointer to the TNode object}
    PNode= ^TNode;
    {TNode object itself, assembly of TNodes make a non-circular tree with }
    {any number of children & brothers                                     }
    TNode=object
        {field definitions}
           NodeContents:ContentsPtr;       {Node contents, variable, op or value}
           NodeType:ContentsType;          {Node type, variable, op or value}
           ParentNodePtr:PNode;            {pointer to parent TNode:PNode}
           BrotherNodePtr:PNode;           {pointer to next brother TNode:PNode}
           ChildNodePtr:PNode;             {pointer to first child TNode:PNode}
           {methods definitions, see later for deeper discussion}
           constructor Create(ContentsType:ContentsType;Value:string);
           destructor  Destroy;
           function    AddChild(ContentsType:ContentsType;Value:string):PNode;
           function    AddBrother(ContentsType:ContentsType;Value:string):PNode;
           function    RemoveChild(ItemPosition:integer):boolean;
           function    RemoveBrother(ItemPosition:integer):Boolean;
           function    Child(ItemCount:integer):Pnode;
           function    Brother(ItemCount:integer):Pnode;
           function    Contents:string;
           function    Parent:PNode;
           procedure   Show;
           procedure   ShowLevel(level:integer;var ShowString:string);
           function    ChildCount:integer;
           function    Index:integer;
           function    BrothersCount:integer;
           function    Remove:Boolean;
           function    FindItem(MyContentsType:ContentsType;MyValue:string):PNode;
           function    InsertLevel(BItem:PNode):PNode;
        end;{TNode object ends here}

implementation

uses Dialogs, SysUtils;

{TNode object methods definitions}
{
 NAME:          TNode.FindItem
 INPUT:         Node Type:ContentsType, Node Contents:String
 OUTPUT:        PNode
 PURPOSE:       Parses the whole tree and returns an item matching the request
                returns nil if no such item has been found
}
function TNode.FindItem(MyContentsType:ContentsType;MyValue:string):PNode;
var
   FoundItem:PNode;
begin
   FoundItem:=nil;
   if (NodeType=MyContentsType) and (Contents=MyValue) then begin
      FindItem:=@Self;
      exit;
      end;
   if ChildNodePtr<>nil then FoundItem:=ChildNodePtr^.FindItem(MyContentsType,MyValue);
   if FoundItem<>nil then begin
      FindItem:=FoundItem;
      exit;
      end;
   if BrotherNodePtr<>nil then FoundItem:=BrotherNodePtr^.FindItem(MyContentsType,MyValue);
   if FoundItem<>nil then begin
      FindItem:=FoundItem;
      exit;
      end;
      FindItem:=FoundItem;
   end;

{
 NAME:          TNode.Remove
 INPUT:         void
 OUTPUT:        Boolean (True=operation successful)
 PURPOSE:       Attempts to remove the whole TNode, needs to have a parent
                pointer, all top tree items don't have any
}
function TNode.Remove:Boolean;
begin
   Remove:=False;
   if ParentNodePtr=nil then exit;
   Remove:=ParentNodePtr^.RemoveChild(Index);
   end;

{
 NAME:          TNode.Brother
 INPUT:         Brother Index : integer
 OUTPUT:        PNode
 PURPOSE:       Returns the pointer to a brother
                0 returns it's own pointer
                nil is returned if brother does not exist
}
function TNode.Brother(ItemCount:integer):PNode;
var  i:integer;
     MyBrotherPtr:PNode;
begin
   if ItemCount=0 then begin
      Brother:=@Self;
      exit;
      end;
   MyBrotherPtr:=BrotherNodePtr;
   {if BrotherNodePtr=nil then begin
      Brother:=nil;
      exit;
      end;}

   for i:=1 to ItemCount-1 do begin
       if MyBrotherPtr=nil then begin
          Brother:=nil;
          exit;
          end;
       {if MyBrotherPtr^.BrotherNodePtr=nil then
       if i<ItemCount-1 then begin
          Brother:=nil;
          exit;
          end
          else break;}
       MyBrotherPtr:=MyBrotherPtr^.BrotherNodePtr;
       end;
   Brother:=MyBrotherPtr;
   end; {TNode.Brother}

{
 NAME:          TNode.Child
 INPUT:         Child Index : integer
 OUTPUT:        PNode
 PURPOSE:       returns a pointer to ItemCount 'th child
                nil of none or no such child
}
function TNode.Child(ItemCount:integer):PNode;
var
   i:integer;
   MyBrotherPtr:PNode;
begin
   if Self.ChildNodePtr=nil then begin
      Child:=nil;
      exit;
      end;
   MyBrotherPtr:=Self.ChildNodePtr;
   for i:=0 to ItemCount-1 do begin
       if MyBrotherPtr=nil then begin
          Child:=nil;
          exit;
          end;
      MyBrotherPtr:=MyBrotherPtr^.BrotherNodePtr;
      end;
  Child:=MyBrotherPtr;
  end;

{
 NAME:          TNode.RemoveBrother
 INPUT:         Brother Index : integer
 OUTPUT:        Boolean (True means operation successfull)
 PURPOSE:       remove a brother of a node indexed by input
 revisions:     20.05.96 (bug in last node removal)
}
function TNode.RemoveBrother(ItemPosition:integer):boolean;
var
     LinkPrevious:PNode;
     LinkForward:PNode;
     CurrentNode:PNode;
begin
     if ItemPosition=0 then begin
      if BrotherNodePtr<>nil then begin
         LinkForward:=BrotherNodePtr^.BrotherNodePtr;
         BrotherNodePtr^.BrotherNodePtr:=nil;
         Dispose(BrotherNodePtr,Destroy);
         BrotherNodePtr:=LinkForward;
         RemoveBrother:=True
         end
         else RemoveBrother:=False;
     end
     else begin
       LinkPrevious:=BrotherNodePtr;
       CurrentNode:=BrotherNodePtr;
       while ItemPosition>0 do begin
          ItemPosition:=ItemPosition-1;
          if CurrentNode^.BrotherNodePtr=nil then begin
             RemoveBrother:=False;
             exit;
             end;
          LinkPrevious:=CurrentNode;
          CurrentNode:=CurrentNode^.BrotherNodePtr;
          end;
       Linkforward:=CurrentNode^.BrotherNodePtr;
       CurrentNode^.BrotherNodePtr:=nil;
       Dispose(CurrentNode,Destroy);
       if LinkPrevious<>nil then LinkPrevious^.BrotherNodePtr:=LinkForward;
       RemoveBrother:=true;
     end;
     end;{TNode.RemoveBrother}

{
 NAME:          TNode.RemoveChild
 INPUT:         Child Index : integer
 OUTPUT:        Boolean
 PURPOSE:       Remove Indexed child from TNode
}
function TNode.RemoveChild(ItemPosition:integer):boolean;
var
    LinkForward:PNode;
begin
    if ItemPosition=0 then begin
       if ChildNodePtr<>nil then begin
          LinkForward:=ChildNodePtr^.BrotherNodePtr;
          ChildNodePtr^.BrotherNodePtr:=nil;
          Dispose(ChildNodePtr,Destroy);
          ChildNodePtr:=LinkForward;
          RemoveChild:=True;
       end
       else RemoveChild:=False;
    end
    else begin
          RemoveChild:=ChildNodePtr^.RemoveBrother(ItemPosition-1);
    end;
    end;{TNode.RemoveChild}

{
 NAME:          TNode.AddBrother
 INPUT:         NodeType : ContentsType, NodeValue : string
 OUTPUT:        PNode
 PURPOSE:       Adds a brother with input contents and returns pointer to it
}
function TNode.AddBrother(ContentsType:ContentsType;Value:string):PNode;
var
    LastNodeBrother:PNode;
    ANode:PNode;
begin
    New(ANode,Create(ContentsType,Value));
    AddBrother:=ANode;
    if BrotherNodePtr=nil then begin
       BrotherNodePtr:=ANode;
       Anode^.ParentNodePtr:=ParentNodePtr;
    end
    else begin
    LastNodeBrother:=BrotherNodePtr;
    while LastNodeBrother^.BrotherNodePtr<>nil do begin
          LastNodeBrother:=LastNodeBrother^.BrotherNodePtr;
    end;
    LastNodeBrother^.BrotherNodePtr:=ANode;
    Anode^.ParentNodePtr:=LastNodeBrother^.ParentNodePtr;
    end;
    end;{TNode.AddBrother}

{
 NAME:          TNode.AddChild
 INPUT:         NodeType : ContentsType, NodeValue : string
 OUTPUT:        PNode
 PURPOSE:       Adds a Child with input contents and returns a pointer to it
}
function TNode.AddChild(ContentsType:ContentsType;Value:string):PNode;
var
    LastNodeChild:PNode;
    ANode:PNode;
begin
    New(ANode,Create(ContentsType,Value));
    ANode^.ParentNodePtr:=@Self;
    AddChild:=ANode;
    if ChildNodePtr=nil then begin
       ChildNodePtr:=ANode;
    end
    else begin
    LastNodeChild:=ChildNodePtr;
    while LastNodeChild^.BrotherNodePtr<>nil do begin
          LastNodeChild:=LastNodeChild^.BrotherNodePtr;
    end;
    LastNodeChild^.BrotherNodePtr:=ANode;
    end;
    end;{TNode.AddChild}

{
 NAME:          TNode.Create : constructor
 INPUT:         NodeType : ContentsType, NodeValue: string
 OUTPUT:        void
 PURPOSE        Creates a new node by initializing field values and
                allocating contents record
}
constructor TNode.Create(ContentsType:ContentsType;Value:string);
var
    Code:integer;
    i:extended;
begin
    New(NodeContents);
    NodeType:=ContentsType;
    Case ContentsType of
         NodeSingle :  NodeContents^.MySingle:=Value;
         NodeOperator: NodeContents^.MyOperator:=Value;
         NodeVariable: NodeContents^.MyVariable:=Trim(Value)[1];
         NodeValue:    begin
                       Val(Value,I,Code);
                       NodeContents^.MyValue:=I;
                       end;
         end;
    ChildNodePtr:=nil;
    BrotherNodePtr:=nil;
    ParentNodePtr:=nil;
    end;{TNode constructor}

{
 NAME:          TNode.Destroy : destructor
 INPUT:         void
 OUTPUT:        void
 PURPOSE:       Disposes the node with it's children and brothers
                use Remove to link brothers without removing them
}
destructor TNode.Destroy;
begin
     if ChildNodePtr<>nil then Dispose(ChildNodePtr,Destroy);
     if BrotherNodePtr<>nil then Dispose(BrotherNodePtr,Destroy);
     Dispose(NodeContents);
     end;{TNode destructor}

{
 NAME:          TNode.Contents
 INPUT:         void
 OUTPUT:        string
 PURPOSE:       returns string type for node contents
}
function TNode.Contents:string;
var
   NeedConvert:string;
begin
   case NodeType of
     NodeVariable: Contents:=NodeContents^.MyVariable;
     NodeOperator: Contents:=NodeContents^.MyOperator;
     NodeValue:    begin
                   Str(NodeContents^.MyValue:16:3,NeedConvert);
                   Contents:=NeedConvert;
                   end;
     NodeSingle:   Contents:=NodeContents^.MySingle;
     end;
     end;{TNode.Contents}

{
 NAME:          TNode.Show
 INPUT:         level : integer , 0 is top level of a tree
 OUTPUT:        standard output
 PURPOSE:       writes the tree to standard output
}
procedure TNode.ShowLevel(level:integer;var ShowString:string);
var
   i:integer;
begin
     for i:=0 to level do ShowString:=ShowString+'  ';
     ShowString:=ShowString+Contents+Chr(10)+Chr(13);
     if ChildNodePtr<>nil then begin
        ChildNodePtr^.ShowLevel(level+1,ShowString);
        end;
     if BrotherNodePtr<>nil then begin
        BrotherNodePtr^.ShowLevel(level,ShowString);
        end;
end;

procedure TNode.Show;
var
   ShowString:string;
begin
     ShowString:='';
     ShowLevel(0,ShowString);
     MessageDlg(ShowString,mtInformation,[mbOk],0);
     end;{TNode.Show}

{
 NAME:          TNode.ChildCount
 INPUT:         void
 OUTPUT:        integer
 PURPOSE:       counts the children of a node
}
function TNode.ChildCount:integer;
var
   ChildNode:PNode;
   ChildCounter:integer;
begin
     ChildCounter:=0;
     ChildNode:=ChildNodePtr;
     while ChildNode<>nil do begin
           ChildNode:=ChildNode^.BrotherNodePtr;
           ChildCounter:=ChildCounter+1;
           end;
     ChildCount:=ChildCounter;
     end;

{
 NAME:          TNode.Parent
 INPUT:         void
 OUTPUT:        PNode
 PURPOSE:       returns the pointer to parent node (if possible)
}
function TNode.Parent:PNode;
begin
     Parent:=@Self.ParentNodePtr^;
     end;

{
 NAME:          TNode.BrothersCount
 INPUT:         void
 OUTPUT:        integer
 PURPOSE:       counts all brothers (self included)
                -2 means at top of tree and ParentNode inexistant
}
function TNode.BrothersCount:integer;
begin
     if ParentNodePtr<>nil then
     BrothersCount:=ParentNodePtr^.ChildCount
     else BrothersCount:=-2;
end;

{
 NAME:          TNode.Index
 INPUT:         void
 OUTPUT:        integer
 PURPOSE:       returns the position of the node under the ParentNode
                -2 means no parent node
                -1 means the tree is corrupt
}
function TNode.Index:integer;
var CurrentNode:PNode;
    CurrentIndex:integer;
begin
   CurrentIndex:=0;
   if ParentNodePtr=nil then begin
      Index:=-2;        {returns -2 if first level of tree}
      exit;
      end;
   CurrentNode:=ParentNodePtr^.ChildNodePtr;
   if CurrentNode=@Self then begin
      Index:=0;         {if first element, then zero position}
      exit;
      end;
   while CurrentNode<>nil do begin
      CurrentIndex:=CurrentIndex+1;
      CurrentNode:=CurrentNode^.BrotherNodePtr;
      if CurrentNode=nil then break;
      if CurrentNode=@Self then begin
         Index:=CurrentIndex;
         exit;
         end;
      end;
   Index:=-1;
   end;

{
 NAME:          TNode.InsertLevel
 INPUT:         Node : PNode
 OUTPUT:        PNode
 PURPOSE:       - inserts a node into the tree that has no brothers,
                i.e. adds a whole vertical level to the tree
                - adds an item to the new node and returns pointer to it
                This is equal to push the node to the left and add a new
                right item on a binary tree
 note:          pointers have shitty behavior, this seems to work...
                this routine has been rewritten at least 20 times...
}
function TNode.InsertLevel(BItem:PNode):PNode;
var
   NewNode:PNode;
begin
   New(NewNode,Create(NodeType,Contents));
   NewNode^.NodeType:=NodeType;
   NewNode^.NodeContents^:=NodeContents^;
   NewNode^.ChildNodePtr:=ChildNodePtr;
   NewNode^.BrotherNodePtr:=BrotherNodePtr;
   NewNode^.ParentNodePtr:=@Self;
   NodeType:=BItem^.NodeType;
   NodeContents^:=BItem^.NodeContents^;
   ChildNodePtr:=NewNode;
   BrotherNodePtr:=nil;
   InsertLevel:=AddChild(NodeValue,'0');
end;

{TNode ends here}

end.
