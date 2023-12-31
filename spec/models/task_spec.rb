require 'rails_helper'
RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空の場合' do
      it 'バリデーションにひっかる' do
        task = Task.new(title: '', content: '失敗テスト')
        expect(task).not_to be_valid
      end
    end
    context 'タスクの詳細が空の場合' do
      it 'バリデーションにひっかかる' do
        task = Task.new(title: '失敗テスト', content: '')
        expect(task).not_to be_valid
      end
    end
    context 'タスクのタイトルと詳細に内容が記載されている場合' do
      it 'バリデーションが通る' do
        task = Task.new(title: '成功テスト', content: '成功テスト')
        expect(task).to be_valid
      end
    end
  end
  describe '検索機能' do
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it '検索キーワードを含むタスクが絞り込まれる' do
        task1 = FactoryBot.create(:task, title: 'title1')
        task2 = FactoryBot.create(:task, title: 'title2')
        expect(Task.search_title('2')).to include(task2)
        expect(Task.search_title('2')).not_to include(task1)
        expect(Task.search_title('2').count).to eq 1
      end
    end
    context 'scopeメソッドでステータスを検索した場合' do
      it 'ステータスに完全一致するタスクが絞り込まれる' do
        task1 = FactoryBot.create(:task, status: 'completed')
        task2 = FactoryBot.create(:task, status: 'working')
        task3 = FactoryBot.create(:task, status: 'waiting')
        expect(Task.search_status('completed')).to include(task1)
        expect(Task.search_status('completed')).not_to include(task2,task3)
        expect(Task.search_status('completed').count).to eq 1
      end
    end
    context 'タイトルをあいまい検索、ステータスを検索した場合' do
      it '検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる' do
        task1 = FactoryBot.create(:task, title: 'title1', status: 'completed')
        task2 = FactoryBot.create(:task, title: 'title2', status: 'working')
        task3 = FactoryBot.create(:task, title: 'title3', status: 'waiting')
        expect(Task.search_title('1')).to include(task1)
        expect(Task.search_status('completed')).to include(task1)
        expect(Task.search_title('1')).not_to include(task2,task3)
        expect(Task.search_status('completed')).not_to include(task2,task3)
        expect(Task.search_title('1').count).to eq 1
        expect(Task.search_status('completed').count).to eq 1
      end
    end
  end
end