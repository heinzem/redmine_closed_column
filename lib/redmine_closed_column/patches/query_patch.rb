module RedmineClosedColumn
  module Patches
    module QueryPatch
      
      def available_columns_with_first_closed_date
        returning available_columns_without_first_closed_date do |columns|
          columns << QueryColumn.new(:first_closed_date,
            :caption => :label_first_closed_date,
	    :sortable => "(SELECT journals.created_on FROM journals, journal_details WHERE journals.journalized_id = t0_r0 AND journals.id = journal_details.journal_id AND journal_details.prop_key = 'status_id' AND journal_details.property = 'attr' AND journal_details.value IN (SELECT is_close.id FROM issue_statuses is_close WHERE is_close.is_closed = 1) ORDER BY journals.created_on DESC LIMIT 1)"
          ) unless columns.detect{ |c| c.name == :first_closed_date }
        end
      end

      def available_columns_with_last_closed_date
        returning available_columns_without_last_closed_date do |columns|
          columns << QueryColumn.new(:last_closed_date,
            :caption => :label_last_closed_date,
	    :sortable => "(SELECT journals.created_on FROM journals, journal_details WHERE journals.journalized_id = t0_r0 AND journals.id = journal_details.journal_id AND journal_details.prop_key = 'status_id' AND journal_details.property = 'attr' AND journal_details.value IN (SELECT is_close.id FROM issue_statuses is_close WHERE is_close.is_closed = 1) ORDER BY journals.created_on LIMIT 1)"
          ) unless columns.detect{ |c| c.name == :last_closed_date }
        end
      end

      def available_columns_with_count_closes
        returning available_columns_without_count_closes do |columns|
          columns << QueryColumn.new(:count_closes,
            :caption => :label_count_closes,
	    :sortable => "(SELECT count(journals.created_on) FROM journals, journal_details WHERE journals.journalized_id = t0_r0 AND journals.id = journal_details.journal_id AND journal_details.prop_key = 'status_id' AND journal_details.property = 'attr' AND journal_details.value IN (SELECT is_close.id FROM issue_statuses is_close WHERE is_close.is_closed = 1) ORDER BY journals.created_on)"
          ) unless columns.detect{ |c| c.name == :count_closes }
        end
      end

      def self.included(klass)
        klass.send :alias_method_chain, :available_columns, :first_closed_date
        klass.send :alias_method_chain, :available_columns, :last_closed_date
        klass.send :alias_method_chain, :available_columns, :count_closes
      end
      
    end
  end
end
