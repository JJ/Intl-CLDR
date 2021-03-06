use Intl::CLDR::Immutability;

unit class CLDR-DateFormats is CLDR-ItemNew;

use Intl::CLDR::Types::DateFormat;

has $!parent;
has CLDR-DateFormat $.full;
has CLDR-DateFormat $.long;
has CLDR-DateFormat $.medium;
has CLDR-DateFormat $.short;

#| Creates a new CLDR-Dates object
method new(|c) {
    self.bless!bind-init: |c;
}

submethod !bind-init(\blob, uint64 $offset is rw, \parent) {
    $!parent := parent;

    $!full   = CLDR-DateFormat.new: blob, $offset, self;
    $!long   = CLDR-DateFormat.new: blob, $offset, self;
    $!medium = CLDR-DateFormat.new: blob, $offset, self;
    $!short  = CLDR-DateFormat.new: blob, $offset, self;

    self
}

##`<<<<<#GENERATOR: This method should only be uncommented out by the parsing script
method encode(%date-formats) {
    my $result = buf8.new;

    my $*date-format-width;

    $*date-format-width = 'full';
    $result ~= CLDR-DateFormat.encode: %date-formats<full>;
    $*date-format-width = 'long';
    $result ~= CLDR-DateFormat.encode: %date-formats<long>;
    $*date-format-width = 'medium';
    $result ~= CLDR-DateFormat.encode: %date-formats<medium>;
    $*date-format-width = 'short';
    $result ~= CLDR-DateFormat.encode: %date-formats<short>;

    $result;
}
method parse(\base, \xml) {
    use Intl::CLDR::Util::XML-Helper;
    for xml.&elems('dateFormatLength') {
        # There should really only be one pattern.
        # There isn't always (read: rarely if ever) a display name.
        my $length = .<type>;
        my $format = .&elem('dateFormat');

        base{$length}<pattern>     = $format.&elem('pattern').&contents;
        base{$length}<displayName> = $format.&elem('displayName').&contents;
    }
}
#>>>>>#GENERATOR
