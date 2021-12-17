
FORWARDDELETE_TESTS = {
  'id':          'FD',
  'caption':     'Forward-Delete Tests',
  'command':     'forwardDelete',
  'checkAttrs':  True,
  'checkStyle':  False,

  'Proposed': [
    { 'desc':       '',
      'tests':      [
      ]
    },

    { 'desc':       'forward-delete single characters',
      'tests':      [
        { 'id':          'CHAR-1_SC',
          'desc':        'Delete 1 character',
          'pad':         'foo^barbaz',
          'expected':    'foo^arbaz' },

        { 'id':          'CHAR-2_SC',
          'desc':        'Delete 1 pre-composed character o with diaeresis',
          'pad':         'fo^&#xF6;barbaz',
          'expected':    'fo^barbaz' },

        { 'id':          'CHAR-3_SC',
          'desc':        'Delete 1 character with combining diaeresis above',
          'pad':         'fo^o&#x0308;barbaz',
          'expected':    'fo^barbaz' },

        { 'id':          'CHAR-4_SC',
          'desc':        'Delete 1 character with combining diaeresis below',
          'pad':         'fo^o&#x0324;barbaz',
          'expected':    'fo^barbaz' },

        { 'id':          'CHAR-5_SC',
          'desc':        'Delete 1 character with combining diaeresis above and below',
          'pad':         'fo^o&#x0308;&#x0324;barbaz',
          'expected':    'fo^barbaz' },

        { 'id':          'CHAR-6_SC',
          'desc':        'Delete 1 character with enclosing square',
          'pad':         'fo^o&#x20DE;barbaz',
          'expected':    'fo^barbaz' },

        { 'id':          'CHAR-7_SC',
          'desc':        'Delete 1 character with combining long solidus overlay',
          'pad':         'fo^o&#x0338;barbaz',
          'expected':    'fo^barbaz' }
      ]
    },

    { 'desc':       'forward-delete text selections',
      'tests':      [
        { 'id':          'TEXT-1_SI',
          'desc':        'Delete text selection',
          'pad':         'foo[bar]baz',
          'expected':    'foo^baz' },
          
        { 'id':          'B-1_SE',
          'desc':        'Forward-delete at end of span',
          'pad':         'foo<b>bar^</b>baz',
          'expected':    'foo<b>bar^</b>az' },

        { 'id':          'B-1_SB',
          'desc':        'Forward-delete from position before span',
          'pad':         'foo^<b>bar</b>baz',
          'expected':    'foo^<b>ar</b>baz' },

        { 'id':          'B-1_SW',
          'desc':        'Delete selection that wraps the whole span content',
          'pad':         'foo<b>[bar]</b>baz',
          'expected':    'foo^baz' },

        { 'id':          'B-1_SO',
          'desc':        'Delete selection that wraps the whole span',
          'pad':         'foo[<b>bar</b>]baz',
          'expected':    'foo^baz' },

        { 'id':          'B-1_SL',
          'desc':        'Delete oblique selection that starts before span',
          'pad':         'foo[bar<b>baz]quoz</b>quuz',
          'expected':    'foo^<b>quoz</b>quuz' },

        { 'id':          'B-1_SR',
          'desc':        'Delete oblique selection that ends after span',
          'pad':         'foo<b>bar[baz</b>quoz]quuz',
          'expected':    'foo<b>bar^</b>quuz' },

        { 'id':          'B.I-1_SM',
          'desc':        'Delete oblique selection that starts and ends in different spans',
          'pad':         'foo<b>bar[baz</b><i>qoz]quuz</i>quuuz',
          'expected':    'foo<b>bar^</b><i>quuz</i>quuuz' },

        { 'id':          'GEN-1_SE',
          'desc':        'Delete at end of span with generated content',
          'pad':         'foo<gen>bar^</gen>baz',
          'expected':    'foo<gen>bar^</gen>az' },

        { 'id':          'GEN-1_SB',
          'desc':        'Delete from position before span with generated content',
          'pad':         'foo^<gen>bar</gen>baz',
          'expected':    'foo^<gen>ar</gen>baz' }
      ]
    },

    { 'desc':       'forward-delete paragraphs',
      'tests':      [
        { 'id':          'P2-1_SE1',
          'desc':        'Delete from collapsed selection at end of paragraph - should merge with next',
          'pad':         '<p>foobar^</p><p>bazqoz</p>',
          'expected':    '<p>foobar^bazqoz</p>' },

        { 'id':          'P2-1_SI1',
          'desc':        'Delete non-collapsed selection at end of paragraph - should not merge with next',
          'pad':         '<p>foo[bar]</p><p>bazqoz</p>',
          'expected':    '<p>foo^</p><p>bazqoz</p>' },

        { 'id':          'P2-1_SM',
          'desc':        'Delete non-collapsed selection spanning 2 paragraphs - should merge them',
          'pad':         '<p>foo[bar</p><p>baz]qoz</p>',
          'expected':    '<p>foo^qoz</p>' }
      ]
    },

    { 'desc':       'forward-delete lists and list items',
      'tests':      [
        { 'id':          'OL-LI2-1_SO1',
          'desc':        'Delete fully wrapped list item',
          'pad':         'foo<ol>{<li>bar</li>}<li>baz</li></ol>qoz', 
          'expected':    ['foo<ol>|<li>baz</li></ol>qoz',
                          'foo<ol><li>^baz</li></ol>qoz'] },

        { 'id':          'OL-LI2-1_SM',
          'desc':        'Delete oblique range between list items within same list',
          'pad':         'foo<ol><li>ba[r</li><li>b]az</li></ol>qoz',
          'expected':    'foo<ol><li>ba^az</li></ol>qoz' },

        { 'id':          'OL-LI-1_SW',
          'desc':        'Delete contents of last list item (list should remain)',
          'pad':         'foo<ol><li>[foo]</li></ol>qoz',
          'expected':    ['foo<ol><li>|</li></ol>qoz',
                          'foo<ol><li>^</li></ol>qoz'] },

        { 'id':          'OL-LI-1_SO',
          'desc':        'Delete last list item of list (should remove entire list)',
          'pad':         'foo<ol>{<li>foo</li>}</ol>qoz',
          'expected':    'foo^qoz' }
      ]
    },

    { 'desc':       'forward-delete with strange selections',
      'tests':      [
        { 'id':          'HR.BR-1_SM',
          'desc':        'Delete selection that starts and ends within nodes that don\'t have children',
          'pad':         'foo<hr {>bar<br }>baz',
          'expected':    'foo<hr>|<br>baz' }
      ]
    },

    { 'desc':       'forward-delete from immediately before a table',
      'tests':      [
        { 'id':          'TABLE-1_SB',
          'desc':        'Delete from position immediately before table (should have no effect)',
          'pad':         'foo^<table><tbody><tr><td>bar</td></tr></tbody></table>baz',
          'expected':    'foo^<table><tbody><tr><td>bar</td></tr></tbody></table>baz' }
      ]
    },

    { 'desc':       'forward-delete within table cells',
      'tests':      [
        { 'id':          'TD-1_SE',
          'desc':        'Delete from end of last cell (should have no effect)',
          'pad':         'foo<table><tbody><tr><td>bar^</td></tr></tbody></table>baz',
          'expected':    'foo<table><tbody><tr><td>bar^</td></tr></tbody></table>baz' },

        { 'id':          'TD2-1_SE1',
          'desc':        'Delete from end of inner cell (should have no effect)',
          'pad':         'foo<table><tbody><tr><td>bar^</td><td>baz</td></tr></tbody></table>quoz',
          'expected':    'foo<table><tbody><tr><td>bar^</td><td>baz</td></tr></tbody></table>quoz' },

        { 'id':          'TD2-1_SM',
          'desc':        'Delete with selection spanning 2 cells',
          'pad':         'foo<table><tbody><tr><td>ba[r</td><td>b]az</td></tr></tbody></table>quoz',
          'expected':    'foo<table><tbody><tr><td>ba^</td><td>az</td></tr></tbody></table>quoz' }
      ]
    },

    { 'desc':       'forward-delete table rows',
      'tests':      [
        { 'id':          'TR3-1_SO1',
          'desc':        'Delete first table row',
          'pad':         '<table><tbody>{<tr><td>A</td></tr>}<tr><td>B</td></tr><tr><td>C</td></tr></tbody></table>',
          'expected':    ['<table><tbody>|<tr><td>B</td></tr><tr><td>C</td></tr></tbody></table>',
                          '<table><tbody><tr><td>^B</td></tr><tr><td>C</td></tr></tbody></table>'] },

        { 'id':          'TR3-1_SO2',
          'desc':        'Delete middle table row',
          'pad':         '<table><tbody><tr><td>A</td></tr>{<tr><td>B</td></tr>}<tr><td>C</td></tr></tbody></table>',
          'expected':    ['<table><tbody><tr><td>A</td></tr>|<tr><td>C</td></tr></tbody></table>',
                          '<table><tbody><tr><td>A</td></tr><tr><td>^C</td></tr></tbody></table>'] },

        { 'id':          'TR3-1_SO3',
          'desc':        'Delete last table row',
          'pad':         '<table><tbody><tr><td>A</td></tr><tr><td>B</td></tr>{<tr><td>C</td></tr>}</tbody></table>',
          'expected':    ['<table><tbody><tr><td>A</td></tr><tr><td>B</td></tr>|</tbody></table>',
                          '<table><tbody><tr><td>A</td></tr><tr><td>B^</td></tr></tbody></table>'] },

        { 'id':          'TR2rs:2-1_SO1',
          'desc':        'Delete first table row where a cell has rowspan 2',
          'pad':         '<table><tbody>{<tr><td>A</td><td rowspan=2>R</td></tr>}<tr><td>B</td></tr></tbody></table>',
          'expected':    ['<table><tbody>|<tr><td>B</td><td>R</td></tr></tbody></table>',
                          '<table><tbody><tr><td>^B</td><td>R</td></tr></tbody></table>'] },

        { 'id':          'TR2rs:2-1_SO2',
          'desc':        'Delete second table row where a cell has rowspan 2',
          'pad':         '<table><tbody><tr><td>A</td><td rowspan=2>R</td></tr>{<tr><td>B</td></tr>}</tbody></table>',
          'expected':    ['<table><tbody><tr><td>A</td><td>R</td></tr>|</tbody></table>',
                          '<table><tbody><tr><td>A</td><td>R^</td></tr></tbody></table>'] },

        { 'id':          'TR3rs:3-1_SO1',
          'desc':        'Delete first table row where a cell has rowspan 3',
          'pad':         '<table><tbody>{<tr><td>A</td><td rowspan=3>R</td></tr>}<tr><td>B</td></tr><tr><td>C</td></tr></tbody></table>',
          'expected':    ['<table><tbody>|<tr><td>A</td><td rowspan="2">R</td></tr><tr><td>C</td></tr></tbody></table>',
                          '<table><tbody><tr><td>^A</td><td rowspan="2">R</td></tr><tr><td>C</td></tr></tbody></table>'] },

        { 'id':          'TR3rs:3-1_SO2',
          'desc':        'Delete middle table row where a cell has rowspan 3',
          'pad':         '<table><tbody><tr><td>A</td><td rowspan=3>R</td></tr>{<tr><td>B</td></tr>}<tr><td>C</td></tr></tbody></table>',
          'expected':    ['<table><tbody><tr><td>B</td><td rowspan="2">R</td></tr>|<tr><td>C</td></tr></tbody></table>',
                          '<table><tbody><tr><td>B</td><td rowspan="2">R</td></tr><tr><td>^C</td></tr></tbody></table>'] },

        { 'id':          'TR3rs:3-1_SO3',
          'desc':        'Delete last table row where a cell has rowspan 3',
          'pad':         '<table><tbody><tr><td>A</td><td rowspan=3>R</td></tr><tr><td>B</td></tr>{<tr><td>C</td></tr>}</tbody></table>',
          'expected':    ['<table><tbody><tr><td>A</td><td rowspan="2">R</td></tr><tr><td>B</td></tr>|</tbody></table>',
                          '<table><tbody><tr><td>A</td><td rowspan="2">R</td></tr><tr><td>B^</td></tr></tbody></table>'] }
      ]
    },

    { 'desc':       'delete with non-editable nested content',
      'tests':      [
        { 'id':         'DIV:ce:false-1_SO',
          'desc':       'Delete nested non-editable <div>',
          'pad':        'foo[bar<div contenteditable="false">NESTED</div>baz]qoz',
          'expected':   'foo^qoz' },

        { 'id':         'DIV:ce:false-1_SB',
          'desc':       'Delete from immediately before a nested non-editable <div>',
          'pad':        'foobar^<div contenteditable="false">NESTED</div>bazqoz',
          'expected':   'foobar^bazqoz' },

        { 'id':         'DIV:ce:false-1_SL',
          'desc':       'Delete nested non-editable <div> with oblique selection',
          'pad':        'foo[bar<div contenteditable="false">NES]TED</div>bazqoz',
          'expected':   [ 'foo^<div contenteditable="false">NESTED</div>bazqoz',
                          'foo<div contenteditable="false">[NES]TED</div>bazqoz' ] },

        { 'id':         'DIV:ce:false-1_SR',
          'desc':       'Delete nested non-editable <div> with oblique selection',
          'pad':        'foobar<div contenteditable="false">NES[TED</div>baz]qoz',
          'expected':   [ 'foobar<div contenteditable="false">NESTED</div>^qoz',
                          'foobar<div contenteditable="false">NES[TED]</div>qoz' ] },

        { 'id':         'DIV:ce:false-1_SI',
          'desc':       'Delete inside nested non-editable <div> (should be no-op)',
          'pad':        'foobar<div contenteditable="false">NE[ST]ED</div>bazqoz',
          'expected':   'foobar<div contenteditable="false">NE[ST]ED</div>bazqoz' }
      ]
    },

    { 'desc':       'Delete with display:inline-block',
      'checkStyle':  True,
      'tests':      [
        { 'id':         'SPAN:d:ib-1_SC',
          'desc':       'Delete inside an inline-block <span>',
          'pad':        'foo<span style="display: inline-block">bar^baz</span>qoz',
          'expected':   'foo<span style="display: inline-block">bar^az</span>qoz' },

        { 'id':         'SPAN:d:ib-1_SA',
          'desc':       'Delete from immediately before an inline-block <span>',
          'pad':        'foo^<span style="display: inline-block">barbaz</span>qoz',
          'expected':   'foo^<span style="display: inline-block">arbaz</span>qoz' },

        { 'id':         'SPAN:d:ib-2_SL',
          'desc':       'Delete with nested inline-block <span>, oblique selection',
          'pad':        'foo[DEL<span style="display: inline-block">ETE]bar</span>baz',
          'expected':   'foo^<span style="display: inline-block">bar</span>baz' },

        { 'id':         'SPAN:d:ib-3_SR',
          'desc':       'Delete with nested inline-block <span>, oblique selection',
          'pad':        'foo<span style="display: inline-block">bar[DEL</span>ETE]baz',
          'expected':   'foo<span style="display: inline-block">bar^</span>baz' },

        { 'id':         'SPAN:d:ib-4i_SI',
          'desc':       'Delete with nested inline-block <span>, oblique selection',
          'pad':        'foo<span style="display: inline-block">bar[DELETE]baz</span>qoz',
          'expected':   'foo<span style="display: inline-block">bar^baz</span>qoz' },

        { 'id':         'SPAN:d:ib-4l_SI',
          'desc':       'Delete with nested inline-block <span>, oblique selection',
          'pad':        'foo<span style="display: inline-block">[DELETE]barbaz</span>qoz',
          'expected':   'foo<span style="display: inline-block">^barbaz</span>qoz' },

        { 'id':         'SPAN:d:ib-4r_SI',
          'desc':       'Delete with nested inline-block <span>, oblique selection',
          'pad':        'foo<span style="display: inline-block">barbaz[DELETE]</span>qoz',
          'expected':   'foo<span style="display: inline-block">barbaz^</span>qoz' }
      ]
    }
  ]
}


