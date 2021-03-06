# encoding: utf-8
# frozen_string_literal: true

#
#
#
# WARNING: Some of the examples below contain literal tabs.
# Make sure that your IDE doesn't replace them with spaces.
#
#
#

require 'spec_helper'

describe JsRegex::Converter::EscapeConverter do
  it 'lets backslashes pass through' do
    given_the_ruby_regexp(/\\/)
    expect_js_regex_to_be(/\\/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: '\\', with_results: %w(\\))
  end

  it 'preserves escaped groups' do
    given_the_ruby_regexp(/\(1\)/)
    expect_js_regex_to_be(/\(1\)/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: '(1)', with_results: ["(1)"])
  end

  it 'preserves escaped literals' do
    given_the_ruby_regexp(/\j/)
    expect_js_regex_to_be(/\j/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: 'ijk', with_results: %w(j))
  end

  it 'preserves escaped dots' do
    given_the_ruby_regexp(/\./)
    expect_js_regex_to_be(/\./)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: 'a.b', with_results: %w(.))
  end

  it 'preserves escaped quantifiers' do
    given_the_ruby_regexp(/\?\*\+/)
    expect_js_regex_to_be(/\?\*\+/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: 'a?*+b', with_results: %w(?*+))
  end

  it 'preserves newline escapes' do
    given_the_ruby_regexp(/\n/)
    expect_js_regex_to_be(/\n/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: "a\nb", with_results: ["\n"])
  end

  it 'preservers carriage return escapes' do
    given_the_ruby_regexp(/\r/)
    expect_js_regex_to_be(/\r/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: "abc\r123", with_results: ["\r"])
  end

  it 'preserves vertical tab escapes' do
    given_the_ruby_regexp(/\t/)
    expect_js_regex_to_be(/\t/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: "a\tb", with_results: ["\t"])
  end

  it 'preserves horizontal tab escapes' do
    given_the_ruby_regexp(/\v/)
    expect_js_regex_to_be(/\v/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: "a\vb", with_results: ["\v"])
  end

  it 'preserves form feed escapes' do
    given_the_ruby_regexp(/\f/)
    expect_js_regex_to_be(/\f/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: "a\fb", with_results: ["\f"])
  end

  it 'preserves escaped interval brackets' do
    given_the_ruby_regexp(/\{\}/)
    expect_js_regex_to_be(/\{\}/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: 'a{}b', with_results: %w({}))
  end

  it 'preserves escaped set brackets' do
    given_the_ruby_regexp(/\[\]/)
    expect_js_regex_to_be(/\[\]/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: 'a[]b', with_results: %w([]))
  end

  it 'preserves escaped meta chars / types' do
    given_the_ruby_regexp(/\\h\\H\\s\\S\\d\\D\\w\\W/)
    expect_js_regex_to_be(/\\h\\H\\s\\S\\d\\D\\w\\W/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string:       'h\\h\\H\\s\\S\\d\\D\\w\\W',
                                with_results: ['\\h\\H\\s\\S\\d\\D\\w\\W'])
  end

  it 'preserves escaped bol/eol anchors' do
    given_the_ruby_regexp(/\^\$/)
    expect_js_regex_to_be(/\^\$/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: '^$', with_results: ['^$'])
  end

  it 'preserves escaped bos/eos anchors' do
    given_the_ruby_regexp(/\\A\\z\\Z/)
    expect_js_regex_to_be(/\\A\\z\\Z/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string:       'A\\A\\z\\Z',
                                with_results: ['\\A\\z\\Z'])
  end

  it 'lets ascii escapes pass through' do
    given_the_ruby_regexp(/\x42/)
    expect_js_regex_to_be(/\x42/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: 'ABC', with_results: ['B'])
  end

  it 'lets unicode / codepoint escapes pass through' do
    given_the_ruby_regexp(/\u263A/)
    expect_js_regex_to_be(/\u263A/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: 'A☺C', with_results: ['☺'])
  end

  it 'lets octal escapes pass through' do
    given_the_ruby_regexp(/\177/)
    expect_js_regex_to_be(/\177/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: "a\177b", with_results: ["\177"])
  end

  it 'replaces escaped literal tabs with \t' do
    given_the_ruby_regexp(/\	/)
    expect_js_regex_to_be(/\t/)
    expect_no_warnings
    expect_ruby_and_js_to_match(string: '	', with_results: ['	'])
  end

  it 'drops the bell char "\a" with warning' do
    given_the_ruby_regexp(/.\a/)
    expect_js_regex_to_be(/./)
    expect_warning
  end

  it 'drops the escape char "\e" with warning' do
    given_the_ruby_regexp(/.\e/)
    expect_js_regex_to_be(/./)
    expect_warning
  end

  it 'drops control sequences of the style "\C-x" with warning' do
    given_the_ruby_regexp(/.\C-d/)
    expect_js_regex_to_be(/./)
    expect_warning
  end

  it 'drops control sequences of the style "\cX" with warning' do
    given_the_ruby_regexp(/.\cD/)
    expect_js_regex_to_be(/./)
    expect_warning
  end

  it 'drops the subexpression rematcher "\G" with warning' do
    given_the_ruby_regexp(/(.)\G/)
    expect_js_regex_to_be(/(.)/)
    expect_warning
  end

  it 'drops ab-named subexpression calls ("\g") with warning' do
    given_the_ruby_regexp(/(?<x>.)\g<x>/)
    expect_js_regex_to_be(/(.)/)
    expect_warning
  end

  it 'drops sq-named subexpression calls ("\g") with warning' do
    given_the_ruby_regexp(/(?'x'.)\g'x'/)
    expect_js_regex_to_be(/(.)/)
    expect_warning
  end

  it 'converts codepoint lists, escaping meta chars and using surrogates' do
    # allow working with old Regexp::Scanner for mutant build
    if Gem::Version.new(Regexp::Parser::VERSION.dup) < Gem::Version.new('0.4.0')
      allow(Regexp::Scanner)
        .to receive(:scan)
        .and_yield(:escape, :codepoint_list, "\\u{61 a 28 1F601}", 0, 17)
    end

    given_the_ruby_regexp(/\u{61 a 28 1F601}/)
    expect(@js_regex.source).to eq('a\\n\\(\\ud83d\\ude01')
    expect_ruby_and_js_to_match(string: "_a\n(😁_", with_results: ["a\n(😁"])
  end
end
