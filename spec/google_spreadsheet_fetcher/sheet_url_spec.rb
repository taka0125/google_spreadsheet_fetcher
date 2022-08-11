RSpec.describe GoogleSpreadsheetFetcher::SheetUrl do
  describe '.parse!' do
    subject { described_class.parse!(url) }

    context 'url is GoogleSpreadSheet Url' do
      context 'has fragment' do
        let(:url) { 'https://docs.google.com/spreadsheets/d/1vR116jAC-T115OJh7tNDfLv1W7y4RNAGpJJW_GwziS0/edit#gid=820199139' }

        it 'returns SheetUrl' do
          result = subject

          expect(result.spreadsheet_id).to eq '1vR116jAC-T115OJh7tNDfLv1W7y4RNAGpJJW_GwziS0'
          expect(result.sheet_id).to eq 820199139
        end
      end

      context 'has not fragment' do
        let(:url) { 'https://docs.google.com/spreadsheets/d/1vR116jAC-T115OJh7tNDfLv1W7y4RNAGpJJW_GwziS0/edit' }

        it 'returns SheetUrl' do
          result = subject

          expect(result.spreadsheet_id).to eq '1vR116jAC-T115OJh7tNDfLv1W7y4RNAGpJJW_GwziS0'
          expect(result.sheet_id).to eq 0
        end
      end
    end

    context 'url is not GoogleSpreadSheet Url' do
      let(:url) { 'https://example.com' }

      it { expect { subject }.to raise_error GoogleSpreadsheetFetcher::InvalidSheetUrl }
    end
  end
end
